FactoryGirl.define do
  factory :department do
    sequence(:natural_key) { |n| "D%04d" % n }
    name 'Department of Government'
    hostname 'department-of-government'
  end
end
