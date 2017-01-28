require 'rails_helper'

RSpec.describe Person, type: :model do
  %i(name contact_details_id).each do |field|
    it { should have_db_column(field).with_options(null: false) }
  end

  it { should have_db_index(:contact_details_id).unique }
  it { should have_db_index(:name) }

  it { should belong_to :contact_details }

  it { should validate_presence_of :name }
  it { should validate_presence_of :contact_details }

  it 'should not be possible for People to share ContactDetails' do
    first_person = FactoryGirl.create :person
    second_person = FactoryGirl.create :person
    second_person.contact_details = first_person.contact_details
    expect(second_person.save).to be_falsy
  end
end
