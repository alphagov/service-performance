FactoryGirl.define do
  factory :delivery_organisation do
    sequence(:natural_key) {|n| 'D%05d' % n }
    name 'Government Delivery Organisation'
    hostname 'government-delivery-organisation'

    department
  end
end
