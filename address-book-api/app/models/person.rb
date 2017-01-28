class Person < ApplicationRecord
  belongs_to :contact_details

  validates :name, :contact_details, presence: true
  validates :contact_details, uniqueness: true
end
