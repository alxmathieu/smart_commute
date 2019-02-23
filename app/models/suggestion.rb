class Suggestion < ApplicationRecord
  belongs_to :itinerary
  belongs_to :inspiration
end
