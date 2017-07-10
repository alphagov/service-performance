class ServiceSerializer < ActiveModel::Serializer
  attributes :type, :natural_key, :name, :hostname, :purpose, :how_it_works,
             :typical_users, :frequency_used, :duration_until_outcome,
             :start_page_url, :paper_form_url

  has_one :department

   def type
     'service'
   end
end
