# Importing departments, and associating them with delivery organisations.
#
# Departments are a special case of delivery organisations, they're the parent,
# or top-level, organisation. The list of delivery organisations is imported from
# the Government Organisation Register, but this lacks the hierarchy information.
#
# In order to create the hierarchy, we supplement this information with our own,
# mapping of delivery organisation to department.
#
# This should be imported after the register has been updated, and it takes a CSV
# file (on stdin) in the following format:
#
#    Organisation ID,Department ID
#    D101,D1
#    D30,D1
#    D2,D2
#
# Usage:
#
#     cat mapping.csv | rails runner 'DepartmentsImporter.new.import'

require 'csv'

class DepartmentsImporter
  def self.import
    new.import
  end

  def import(department_mapping = ARGF, acronym_mapping = nil, output = $stderr)
    @output = output
    @acronyms = {}

    ActiveRecord::Base.transaction do
      department_ids = Set.new
      department_ids_by_organisation = {}

      if !acronym_mapping.blank?
        csv = CSV.new(acronym_mapping, headers: true)
        csv.each do |row|
          @acronyms[row['code']] = row['acronym']
        end
      end

      csv = CSV.new(department_mapping, headers: true)
      csv.each do |row|
        organisation_id = row['Organisation ID']
        department_id = row['Department ID']
        next if organisation_id.nil? || department_id.nil?

        department_ids << department_id
        department_ids_by_organisation[organisation_id] = department_id
      end

      add_departments(department_ids)
      add_delivery_organisations(department_ids_by_organisation)
    end
  end

  def add_departments(department_ids)
    department_ids.each do |department_id|
      delivery_organisation = DeliveryOrganisation.where(natural_key: department_id).first!

      department = Department.where(natural_key: department_id).first_or_initialize
      department.name = delivery_organisation.name
      department.website = delivery_organisation.website
      department.acronym = @acronyms[department_id]

      log = ->(message) do
        @output.puts message % { key: department.natural_key, name: department.name }
      end

      if department.new_record?
        log.("promoting delivery organisation to department: key=%<key>s, name=%<name>s")
      elsif department.changed?
        log.("updating department: key=%<key>s, name=%<name>s")
      else
        log.("ignoring department, no changes: key=%<key>s, name=%<name>s")
      end

      department.save!
    end
  end

  def add_delivery_organisations(department_ids_by_organisation)
    department_ids_by_organisation.each do |organisation_id, department_id|
      department = Department.where(natural_key: department_id).first!
      delivery_organisation = DeliveryOrganisation.where(natural_key: organisation_id).first

      log = ->(message, args = nil) do
        args ||= { key: delivery_organisation.natural_key, department_code: delivery_organisation.department.natural_key }
        @output.puts message % args
      end

      if delivery_organisation
        delivery_organisation.department = department
        if delivery_organisation.changed?
          log.("updating delivery organisation's department: key=%<key>s, department_code=%<department_code>s")
        else
          log.("ignoring delivery organisation, no changes: key=%<key>s, department_code=%<department_code>s")
        end
        delivery_organisation.save!
      else
        log.("unknown delivery organisation: key=%<key>s", key: organisation_id)
      end
    end
  end
end
