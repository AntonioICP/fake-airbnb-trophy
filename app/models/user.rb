class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable

  has_many :requests
  has_many :flats

  validates :first_name, :last_name, :email, presence: true
  validates :email, uniqueness: true
end
