GovernmentServiceDataAPI::Service = Struct.new(
  :key, :name, :purpose, :how_it_works, :typical_users,
  :frequency_used, :duration_until_outcome, :start_page_url,
  :paper_form_url, :department, :delivery_organisation
  ) do

  def self.build(response, department: nil, delivery_organisation: nil)
    new(
      response['natural_key'],
      response['name'],
      response['purpose'],
      response['how_it_works'],
      response['typical_users'],
      response['frequency_used'],
      response['duration_until_outcome'],
      response['start_page_url'],
      response['paper_form_url'],
      department,
      delivery_organisation,
    )
  end
end
