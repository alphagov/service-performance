FactoryGirl.define do
  factory :agency do
    sequence(:natural_key) {|n| 'D%05d' % n }
    name 'Government Agency'
    hostname 'government-agency'

    department
  end
end
