class User < ApplicationRecord
  has_secure_password
 
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }
  
  has_many :collected_plants
  has_many :schedules, through: :collected_plants
end
