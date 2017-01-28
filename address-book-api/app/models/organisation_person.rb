class OrganisationPerson < ApplicationRecord
  belongs_to :person
  belongs_to :organisation
end
