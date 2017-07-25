FactoryGirl.define do
  factory :department do
    sequence(:natural_key) { |n| "D%04d" % n }
    name 'Department of Government'
    website 'http://example.com/department-of-government'
  end
end
