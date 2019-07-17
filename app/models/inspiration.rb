class Inspiration < ApplicationRecord
  has_many :suggestions, dependent: :destroy
  has_many :itineraries, through: :suggestions

  validates :inspiration_type , presence: true
  validates :url , presence: true, uniqueness: true
  validates :name , presence: true, uniqueness: { scope: :url }
  validates :duration , presence: true


end
