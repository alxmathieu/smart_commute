class Suggestion < ApplicationRecord
  belongs_to :itinerary
  belongs_to :inspiration
  delegate :user, to: :itinerary, :allow_nil => true


  validates :itinerary_id , presence: true, uniqueness: { scope: :inspiration_id }

end
