CrossGovernmentServiceDataAPI::Service = Struct.new(
  :key, :name, :purpose, :how_it_works, :typical_users,
  :frequency_used, :duration_until_outcome, :start_page_url,
  :paper_form_url, :department
  ) do

  def self.build(response, department: nil)
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
    )
  end

end
