# Importing service contexts.
#
# The service context, which describes what the service actuall is, is imported
# from a CSV file. This importer will only update existing services which will
# have been imported using the metrics_importer.
#
# The CSV file (on stdin) should have the following headings:
#
#    name,purpose,how_it_works,typical_users,frequency_used,duration_until_outcome,start_page_url
#
# Usage:
#
#     cat service-context.csv | rails runner 'ServiceContextImporter.new.import'
#

require 'csv'

class ServiceContextImporter
  def self.import
    new.import
  end

  def import(input = ARGF, output = $stderr)
    @output = output

    ActiveRecord::Base.transaction do
      csv = CSV.new(input, headers: true)
      csv.each do |row|
        r = row.to_h
        service = service(r["name"])
        next if service.nil?
        service.update(r)
        service.save!
      end
    end
  end

  def service(name)
    Service.where(name: name).first
  end
end
