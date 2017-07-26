class DeliveryOrganisationsImporter
  def import(output = $stderr)
    ActiveRecord::Base.transaction do
      organisations = GovernmentOrganisationRegister::Organisations.new
      organisations.each do |organisation|
        log = ->(message) do
          output.puts message % {key: organisation.key, name: organisation.name}
        end

        if organisation.retired?
          log.("ignoring organisation, retired: key=%{key}, name=%{name}")
          next
        end

        delivery_organisation = DeliveryOrganisation.where(natural_key: organisation.key).first_or_initialize
        delivery_organisation.name = organisation.name
        delivery_organisation.website = organisation.website

        case
        when delivery_organisation.new_record?
          log.("new organisation: key=%{key}, name=%{name}")
        when delivery_organisation.changed?
          log.("updating organisation: key=%{key}, name=%{name}")
        else
          log.("ignoring organisation, no changes: key=%{key}, name=%{name}")
        end

        delivery_organisation.save!
      end
    end
  end
end
