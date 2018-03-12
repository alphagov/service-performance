class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :lockable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :services, foreign_key: :owner_id

  def full_name
    "#{first_name} #{last_name}"
  end

  def to_s
    "#{full_name} <#{email}>"
  end
end
