class Person < ApplicationRecord
  include Concerns::Contactable

  has_one :organisation_person, dependent: :destroy
  has_one :organisation, through: :organisation_person
end
