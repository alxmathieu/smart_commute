class Itinerary < ApplicationRecord
  has_many :suggestions
  belongs_to :user

  validates :start_point , presence: true
  validates :end_point , presence: true
  validates :duration , presence: true

  def duration_in_minutes
    self.duration / 60
  end

end
