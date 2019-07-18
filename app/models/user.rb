class User < ApplicationRecord
  has_many :itineraries
  has_many :suggestions, through: :itineraries
  has_many :language_user_joints
  has_many :languages, through: :language_user_joints

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def already_suggested_inspirations
    suggestions = self.suggestions
    already_suggested_inspirations = []
    suggestions.each do |suggestion|
      already_suggested_inspirations << suggestion.inspiration unless suggestion.inspiration.nil?
    end
    already_suggested_inspirations
  end

end
