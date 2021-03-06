require 'rails_helper'

RSpec.describe PeopleController, type: :controller do
  include ContactableResultSpecs

  describe 'GET index' do
    subject(:req) { get :index, params: params }
    let(:params)  { {} }

    it { should have_http_status :ok }

    context 'if there are no People' do
      it 'should return an empty array' do
        expect(result).to eq []
      end
    end

    context 'if there are People' do
      let!(:people)        { FactoryGirl.create_list :person, 2 }
      let(:returned_names) { result.map { |person| person[:name] } }

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

      describe 'when a "matching_name" param is passed' do
        let(:params)        { { matching_name: matching_name } }
        let(:matching_name) { 'crate' }

        it 'should only return the people with names that include the provided substring' do
          people.first.update name: 'Socrates'
          people.second.update name: 'Joan of Arc'
          expect(returned_names).to eq ['Socrates']
        end
      end
    end
  end

  describe 'POST create' do
    subject(:req) { post :create, format: :json, params: params }
    let(:params)  { {} }

    it_should_behave_like 'requiring a contactable param', :person

    context 'with a "person" parameter with a "name"' do
      let(:params)        { { person: person_params } }
      let(:person_params) { { name: name } }
      let(:name)          { 'The French Army' }

      it { should have_http_status :created }

      it 'should create a new Person' do
        expect { req }.to change(Person, :count).by(1)
      end

      it 'should create a new ContactDetails' do
        expect { req }.to change(ContactDetails, :count).by(1)
      end

      describe 'the response body' do
        it_should_behave_like 'returning the Contactable and their ContactDetails' do
          let(:contactable)        { Person.last }
          let(:contactable_result) { result }
        end
      end

      describe 'the new Person' do
        subject(:person) { Person.last }
        before { req }

        it 'should have the supplied name' do
          expect(person.name).to eq name
        end

        it 'should have the new ContactDetails' do
          expect(person.contact_details).to eq ContactDetails.last
        end
      end

      describe 'the new ContactDetails' do
        let(:contact_details) { ContactDetails.last }
        before { req }

        context 'if no contact details were passed' do
          ContactDetails::USER_EDITABLE_PARAMS.each do |field|
            it "should have a nil #{field}" do
              expect(contact_details.send(field)).to be_nil
            end
          end
        end

        context 'if all the ContactDetails fields were passed as the "contact_details" of the ' \
          'person' do
          let(:person_params)          { super().merge contact_details: contact_details_params }
          let(:contact_details_params) { fully_specified_contact_details_params }

          ContactDetails::USER_EDITABLE_PARAMS.each do |field|
            it "should have the specified #{field}" do
              expect(contact_details.send(field)).to eq contact_details_params[field]
            end
          end
        end
      end
    end
  end

  describe 'PUT update' do
    subject(:req)   { put :update, params: params }
    let(:person_id) { -1 }
    let(:params)    { { id: person_id } }

    it_should_behave_like 'requiring a contactable param', :person

    context 'with a "person" parameter with a "name"' do
      let(:params)        { super().merge(person: person_params) }
      let(:person_params) { { name: name } }
      let(:name)          { 'Sigmund Freud' }

      context 'if there is no Person with the specified id' do
        it_should_behave_like 'a not found response', 'person'
      end

      context 'if there is a Person with the specified id' do
        let!(:person)   { FactoryGirl.create :person }
        let(:person_id) { person.id }

        it { should have_http_status :ok }

        it 'should not create a new Person' do
          expect { req }.not_to change(Person, :count)
        end

        it 'should not create a new ContactDetails' do
          expect { req }.not_to change(ContactDetails, :count)
        end

        describe 'the response body' do
          it_should_behave_like 'returning the Contactable and their ContactDetails' do
            let(:contactable)        { person }
            let(:contactable_result) { result }

            before do
              req
              person.reload
            end
          end
        end

        describe 'the stored Person' do
          it 'should have its name changed to the supplied name' do
            expect { req }.to change { person.reload.name }.to name
          end

          describe 'the Person\'s ContactDetails' do
            let(:contact_details) { ContactDetails.last }

            context 'if no contact details were passed' do
              ContactDetails::USER_EDITABLE_PARAMS.each do |field|
                it "should not have its #{field} changed" do
                  expect { req }.not_to change { contact_details.reload.send(field) }
                end
              end
            end

            context 'if all the ContactDetails fields were passed as the "contact_details" of the' \
              ' person' do
              let(:person_params)          { super().merge contact_details: contact_details_params }
              let(:contact_details_params) { fully_specified_contact_details_params }

              ContactDetails::USER_EDITABLE_PARAMS.each do |field|
                it "should have the specified #{field} changed to the passed in value" do
                  expect { req }.to \
                    change { person.reload.contact_details.send(field) }
                    .to contact_details_params[field]
                end
              end
            end
          end
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    subject(:req) { delete :destroy, params: { id: person_id } }
    let(:person_id) { -1 }

    context 'if there is no Person with the specified id' do
      it_should_behave_like 'a not found response', 'person'
    end

    context 'if the Person does exist' do
      let!(:person)   { FactoryGirl.create :person }
      let(:person_id) { person.id }

      it { should have_http_status :ok }

      it 'should delete the Person' do
        expect { req }.to change { Person.find_by(id: person_id) }.to nil
      end

      describe 'the response body' do
        it_should_behave_like 'returning the Contactable and their ContactDetails' do
          let(:contactable)        { person }
          let(:contactable_result) { result }
        end
      end
    end
  end
end
