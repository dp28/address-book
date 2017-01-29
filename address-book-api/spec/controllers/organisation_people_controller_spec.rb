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

  describe 'POST create' do
    subject(:req)         { post :create, format: :json, params: params }
    let(:params)          { { organisation_id: organisation_id } }
    let(:organisation_id) { -1 }

    context 'if the Organisation does not exist' do
      it_should_behave_like 'a not found response', 'organisation'
    end

    context 'if the Organisation does exist' do
      let(:organisation)    { FactoryGirl.create :organisation }
      let(:organisation_id) { organisation.id }

      it_should_behave_like 'requiring a parameter', :person_id

      context 'with a "person_id"' do
        let(:params)    { super().merge person_id: person_id }
        let(:person_id) { -1 }

        context 'and the Person does not exist' do
          it_should_behave_like 'a not found response', 'person'
        end

        context 'and the Person does exist' do
          let(:person)    { FactoryGirl.create :person }
          let(:person_id) { person.id }

          it { should have_http_status :created }

          it 'should create a new OrganisationPerson' do
            expect { req }.to change(OrganisationPerson, :count).by(1)
          end

          it 'should add the Person to the Organisation' do
            expect { req }.to change { organisation.reload.people.include? person }.to true
          end

          describe 'the response body' do
            subject { result }
            it { should eq(success: true) }
          end

          context 'and the Person is already part of the Organisation' do
            before { organisation.people << person }

            it { should have_http_status :ok }

            it 'should not create a new OrganisationPerson' do
              expect { req }.not_to change(OrganisationPerson, :count)
            end

            it 'should not remove the Person from the Organisation' do
              expect { req }.not_to change { organisation.reload.people.include? person }.from true
            end

            describe 'the response body' do
              subject { result }
              it { should eq(success: true) }
            end
          end
        end
      end
    end
  end

  describe 'DELETE destroy' do
    subject(:req)         { delete :destroy, format: :json, params: params }
    let(:params)          { { organisation_id: organisation_id, id: person_id } }
    let(:organisation_id) { -1 }
    let(:person_id)       { -1 }

    context 'if the Organisation does not exist' do
      it_should_behave_like 'a not found response', 'organisation'
    end

    context 'if the Organisation does exist' do
      let(:organisation)    { FactoryGirl.create :organisation }
      let(:organisation_id) { organisation.id }

      context 'and the Person does exist' do
        let(:person)    { FactoryGirl.create :person }
        let(:person_id) { person.id }

        context 'but is not part of the Organisation' do
          it_should_behave_like 'a not found response', 'person'
        end

        context 'and the Person is part of the Organisation' do
          before { organisation.people << person }

          it { should have_http_status :ok }

          it 'should delete a OrganisationPerson' do
            expect { req }.to change(OrganisationPerson, :count).by(-1)
          end

          it 'should remove the Person to the Organisation' do
            expect { req }.to change { organisation.reload.people.include? person }.to false
          end
        end
      end
    end
  end
end
