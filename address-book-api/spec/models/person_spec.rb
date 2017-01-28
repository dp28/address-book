require 'rails_helper'

RSpec.describe Person, type: :model do
  include ContactableSpecs

  it_should_behave_like 'a model with ContactDetails' do
    let(:factory_name) { :person }
  end
end
