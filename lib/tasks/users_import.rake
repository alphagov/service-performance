# Imports users from a CSV file
#
# Run with:
#     rake users_import:load < users.csv
#
# Where the first column is the user's name, the second their email
# and the third is the name of the service
require 'csv'

namespace :users_import do
  desc "Import users from a CSV and assign to a service"
  task load: :environment do
    CSV($stdin, row_sep: "\r\n").each do |row|
      name = row[0]
      email = row[1].downcase.strip
      service_name = row[2]
      parsed_name = name.split(' ')

      user = User.where(email: email).first || User.create
      user.email = email
      user.password = Devise.friendly_token.first(32)
      user.first_name = parsed_name[0]
      user.last_name = parsed_name[1]
      user.save!

      service = Service.where(name: service_name).first
      if service.nil?
        puts "! Failed to find service #{service_name}. User created but not assigned."
        next
      end
      service.owner = user
      service.save!

      puts "Added #{user} to #{service}"
    end
  end
end
