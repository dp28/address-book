require 'rails_helper'

RSpec.describe OrganisationPeopleController, type: :controller do
  include ContactableResultSpecs

  describe 'GET index' do
    subject(:req)         { get :index, params: { organisation_id: organisation_id } }
    let(:organisation_id) { -1 }

    context 'if the Organisation does not exist' do
      it_should_behave_like 'a not found response', 'organisation'
    end

    context 'if the Organisation does exist' do
      let(:organisation)    { FactoryGirl.create :organisation }
      let(:organisation_id) { organisation.id }

      it { should have_http_status :ok }

      context 'if there are no People in the Organisation' do
        it 'should return an empty array' do
          expect(result).to eq []
        end
      end

      context 'if there are only People in other Organisations' do
        before do
          other_organisation = FactoryGirl.create :organisation
          other_organisation.people << FactoryGirl.create(:person)
        end

        it 'should return an empty array' do
          expect(result).to eq []
        end
      end

      context 'if there are People in the Organisation' do
        let(:people)         { FactoryGirl.create_list :person, 2 }
        let(:returned_names) { result.map { |person| person[:name] } }

        before { organisation.people << people }

        it 'should have a result for each person' do
          expect(result.size).to eq people.size
        end

        it 'should return the people sorted by name' do
          expect(returned_names).to eq people.map(&:name).sort
        end

        describe 'the result for each Person' do
          it_should_behave_like 'returning the Contactable and their ContactDetails' do
            let(:contactable)        { people.sort_by(&:name).first }
            let(:contactable_result) { result.first }
          end
        end
      end
    end
  end
end
