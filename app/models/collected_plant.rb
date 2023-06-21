class CollectedPlant < ApplicationRecord
  belongs_to :user
  belongs_to :plant
  has_one :schedule

  validates :user_id, presence: true
  validates :plant_id, presence: true

  accepts_nested_attributes_for :plant
  accepts_nested_attributes_for :schedule
end
