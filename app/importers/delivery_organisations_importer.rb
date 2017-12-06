class DeliveryOrganisationsImporter
  def self.import
    new.import
  end

  def import(acronym_mappings = nil, output = $stderr)
    @acronyms = {}

    ActiveRecord::Base.transaction do
      load_acronyms(acronym_mappings) if !acronym_mappings.blank?

      organisations = GovernmentOrganisationRegister::Organisations.new
      organisations.each do |organisation|
        log = ->(message) do
          output.puts message % { key: organisation.key, name: organisation.name }
        end

        if organisation.retired?
          log.("ignoring organisation, retired: key=%<key>s, name=%<name>s")
          next
        end

        delivery_organisation = DeliveryOrganisation.where(natural_key: organisation.key).first_or_initialize
        delivery_organisation.name = organisation.name
        delivery_organisation.website = organisation.website
        delivery_organisation.acronym = @acronyms[organisation.key]

        if delivery_organisation.new_record?
          log.("new organisation: key=%<key>s, name=%<name>s")
        elsif delivery_organisation.changed?
          log.("updating organisation: key=%<key>s, name=%<name>s")
        else
          log.("ignoring organisation, no changes: key=%<key>s, name=%<name>s")
        end

        delivery_organisation.save!
      end
    end
  end

private

  def load_acronyms(acronym_mappings)
    csv = CSV.new(acronym_mappings, headers: true)
    csv.each do |row|
      @acronyms[row['code']] = row['acronym']
    end
  end
end
