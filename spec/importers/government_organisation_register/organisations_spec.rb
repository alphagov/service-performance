require 'rails_helper'

RSpec.describe GovernmentOrganisationRegister::Organisations do
  it 'iterates the organisations', cassette: 'government-organisation-register-organisations' do
    organisations = GovernmentOrganisationRegister::Organisations.new(page_size: 1)
    organisations = organisations.take(5).each.with_object([]) do |organisation, memo|
      memo << [organisation.key, organisation.name]
    end

    expect(organisations).to eq([
      ["OT488", "NHS Resolution"],
      ["D5", "Department for Digital, Culture, Media and Sport"],
      ["DA1020", "Scottish Government"],
      ["PB1218", "Regulator of Social Housing"],
      ["EO1216", "Education and Skills Funding Agency"]
    ])
  end
end
