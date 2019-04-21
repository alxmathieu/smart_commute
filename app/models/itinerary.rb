class Itinerary < ApplicationRecord
  has_many :suggestions
  has_many :inspirations, through: :suggestions
  belongs_to :user, optional: true

  validates :duration , presence: true

  def duration_in_minutes
    self.duration / 60
  end

end
