class Language < ApplicationRecord
  has_many :language_user_joints
  has_many :users, through: :language_user_joints
end
