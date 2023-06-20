class CollectedPlant < ApplicationRecord
  belongs_to :user
  belongs_to :plant

  validates :user_id, presence: true
  validates :plant_id, presence: true
end
