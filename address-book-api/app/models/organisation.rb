class Organisation < ApplicationRecord
  include Concerns::Contactable

  has_many :organisation_people, dependent: :destroy
  has_many :people, through: :organisation_people
end
