require 'rails_helper'

RSpec.describe ContactDetails, type: :model do
  %i(
    street_address additional_street_address city county country postcode email phone_number
  ).each do |field|
    it { should have_db_column field }
  end
end
