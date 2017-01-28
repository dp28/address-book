require 'rails_helper'

RSpec.describe OrganisationPerson, type: :model do
  it { should have_db_column(:organisation_id) }
  it { should have_db_column(:person_id) }

  it { should have_db_index([:organisation_id, :person_id]).unique }

  it { should belong_to(:organisation) }
  it { should belong_to(:person) }
end
