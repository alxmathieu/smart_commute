class Itinerary < ApplicationRecord
  has_many :inspirations
  belongs_to :user

end
