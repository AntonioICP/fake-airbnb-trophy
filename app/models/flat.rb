class Flat < ApplicationRecord
  searchkick word_middle: [:name, :address], suggest: [:name, :address]

  has_many :requests
  belongs_to :user

  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?
end
