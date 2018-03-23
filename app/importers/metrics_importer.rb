# Imports services, and their metrics, and associates them with departments
# and delivery organisations.
#
# We've collected data[1] from various services to aid our user research process.
# Each of the sheets in this document are in the same format, and can be exported
# to CSV. Once placed in the same directory, this script will load them in.
#
# [1]: https://docs.google.com/a/digital.cabinet-office.gov.uk/spreadsheets/d/1Evb18ro1xFp1_rkzktYvOsALBTu4Nx1r9UsV3xXlPC0/edit?usp=sharing
#
# Usage:
#
#     rails runner 'MetricsImporter.import'

require 'csv'
require 'pathname'

class MetricsImporter
  NOT_APPLICABLE = :not_applicable
  NOT_PROVIDED = :not_provided

  def self.import
    data_directory = ARGV[0] && Pathname(ARGV[0])
    new(data_directory: data_directory).import
  end

  def initialize(data_directory: nil)
    data_directory ||= Rails.root.join('data')
    @data_directory = data_directory.expand_path
  end

  def import
    transaction do
      rows.each do |row|
        import_row(row)
      end

      remove_delivery_organisations_without_services
      remove_departments_without_delivery_organisations
    end
  end

  def import_row(row)
    service = service(row.service_name.strip)
    delivery_organisation = delivery_organisation(row.delivery_organisation_name)

    service.natural_key ||= SecureRandom.hex(2)
    service.delivery_organisation_id = delivery_organisation.id
    service.start_page_url = row.service_url
    service.save!

    month_date = row.date
    msm = MonthlyServiceMetrics.find_or_create_by(
      service_id: service.id,
      month: YearMonth.new(month_date.year, month_date.month)
    )

    fields = {
      online_transactions: row.transactions_received_online,
      phone_transactions: row.transactions_received_phone,
      paper_transactions: row.transactions_received_paper,
      face_to_face_transactions: row.transactions_received_face_to_face,
      other_transactions: row.transactions_received_other,
      transactions_processed: row.transactions_processed,
      transactions_processed_accepted: row.transactions_processed_accepted,
      calls_received: row.calls_received,
      calls_received_get_information: row.calls_received_get_information,
      calls_received_perform_transaction: row.calls_received_perform_transaction,
      calls_received_chase_progress: row.calls_received_chase_progress,
      calls_received_challenge_decision: row.calls_received_challenge_a_decision,
      calls_received_other: row.calls_received_other
    }

    fields.each do |k, v|
      # We always update the applicable field in case this is an update and some
      # of the values have changed state from applicable to not_applicable
      applicable_field = "#{k}_applicable"
      service.send("#{applicable_field}=".to_sym, v != :not_applicable)
      msm.send("#{k}=".to_sym, v)
    end

    msm.save!
    service.save!
  end

  def rows
    return to_enum(:rows) unless block_given?

    files = Dir.glob(data_directory.join('*.csv'))
    files.each do |file|
      csv = CSV.open(file.to_s)
      csv.each do |row|
        if row[0].nil?
          row.shift
        end

        row = Row.new(row)
        if row.metrics?
          yield row
        end
      end
    end
  end

private

  attr_reader :data_directory

  def transaction(&block)
    ActiveRecord::Base.transaction(&block)
  end

  def delivery_organisation(name)
    DeliveryOrganisation.where(name: name).first!
  end

  def service(name)
    Service.where(name: name).first_or_initialize
  end

  def remove_delivery_organisations_without_services
    delivery_organisations_with_no_services = DeliveryOrganisation.left_joins(:services).where('services.id IS NULL')
    DeliveryOrganisation.where(id: delivery_organisations_with_no_services).delete_all
  end

  def remove_departments_without_delivery_organisations
    departments_with_no_delivery_organisations = Department.left_joins(:delivery_organisations).where('delivery_organisations.id IS NULL')
    Department.where(id: departments_with_no_delivery_organisations).delete_all
  end

  class Row
    MONTHS = {
      'Jan' => 1,
      'Feb' => 2,
      'Mar' => 3,
      'Apr' => 4,
      'May' => 5,
      'Jun' => 6,
      'Jul' => 7,
      'Aug' => 8,
      'Sep' => 9,
      'Oct' => 10,
      'Nov' => 11,
      'Dec' => 12,
    }.freeze

    DATE_FORMAT = /\A(#{Regexp.union(*MONTHS.keys)})-(\d{2})\z/

    def initialize(row)
      @row = row
    end

    def metrics?
      @row[0] =~ DATE_FORMAT
    end

    def date
      parse_date(@row[0])
    end

    def service_name
      @row[1]
    end

    def department_name
      @row[2]
    end

    def delivery_organisation_name
      @row[3]
    end

    def service_url
      @row[4]
    end

    def transactions_received
      parse_metric(@row[5])
    end

    def transactions_received_online
      parse_metric(@row[6])
    end

    def transactions_received_phone
      parse_metric(@row[7])
    end

    def transactions_received_paper
      parse_metric(@row[8])
    end

    def transactions_received_face_to_face
      parse_metric(@row[9])
    end

    def transactions_received_other
      parse_metric(@row[10])
    end

    def transactions_processed
      parse_metric(@row[11])
    end

    def transactions_processed_accepted
      parse_metric(@row[12])
    end

    def transactions_processed_rejected
      transactions_processed - transactions_processed_accepted
    end

    def calls_received
      parse_metric(@row[13])
    end

    def calls_received_get_information
      parse_metric(@row[14])
    end

    def calls_received_perform_transaction
      parse_metric(@row[15])
    end

    def calls_received_chase_progress
      parse_metric(@row[16])
    end

    def calls_received_challenge_a_decision
      parse_metric(@row[17])
    end

    def calls_received_other
      parse_metric(@row[18])
    end

  private

    def parse_date(value)
      match = value.match(DATE_FORMAT)
      month = match[1]
      year = match[2]
      year = "20#{year}" # Y3K
      Date.new(year.to_i, MONTHS[month], 1)
    end

    def parse_metric(value)
      case value&.strip
      when nil
        raise ArgumentError, 'invalid value: for %s: "%s"' % [value, @row]
      when 'N/A'
        NOT_APPLICABLE
      when 'N/P'
        NOT_PROVIDED
      else
        Integer(value.strip.delete(','))
      end
    end
  end
end
