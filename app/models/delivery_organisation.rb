class DeliveryOrganisation < ApplicationRecord
  belongs_to :department

  validates_presence_of :name
end
