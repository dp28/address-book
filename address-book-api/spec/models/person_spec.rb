require 'rails_helper'

RSpec.describe Person, type: :model do
  include ContactableSpecs

  it_should_behave_like 'a model with ContactDetails' do
    let(:factory_name) { :person }
  end

  it { should have_one(:organisation_person).dependent(:destroy) }
  it { should have_one(:organisation).through(:organisation_person) }
end
