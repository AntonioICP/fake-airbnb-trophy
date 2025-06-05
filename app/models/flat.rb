class Flat < ApplicationRecord
  has_many :requests
  belongs_to :user

  validates :request, presence: true
  validates :user_id, presence: true
end
