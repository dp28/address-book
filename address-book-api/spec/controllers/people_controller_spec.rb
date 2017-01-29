require 'rails_helper'

RSpec.describe PeopleController, type: :controller do
  let(:result) { JSON.parse(req.body).deep_symbolize_keys }

  CONTACT_DETAILS_FIELDS = ContactDetails::USER_EDITABLE_PARAMS

  shared_examples_for 'an API error' do |options|
    it { should have_http_status options.fetch(:status, :bad_request) }

    it 'should have an error message aimed at developers to help with debugging' do
      expect(result[:message]).to match options.fetch(:message)
    end

    it 'should have a machine-parseable key that could be used in transalations' do
      expect(result[:key]).to eq options.fetch(:key)
    end
  end

  shared_examples_for 'requiring a parameter' do |param|
    it_should_behave_like 'an API error', message: /#{param}.*required/, key: 'missing_parameter'
  end

  shared_examples_for 'requiring a "person" param with a "name"' do
    context 'without a "person" parameter' do
      it_should_behave_like 'requiring a parameter', :person
    end

    context 'with a "person" parameter' do
      let(:params)        { super().merge(person: person_params) }
      let(:person_params) { {} }

      context 'without a "name" parameter' do
        it_should_behave_like 'requiring a parameter', 'person.name'
      end
    end
  end

  shared_examples_for 'returning the Person and their ContactDetails' do
    subject { result }

    it 'should have the specified name' do
      expect(result[:name]).to eq person.name
    end

    it 'should have the id of the new Person' do
      expect(result[:id]).to eq person.id
    end

    it 'should have a "contact_details" object' do
      expect(result).to have_key :contact_details
    end

    describe 'the "contact_details" object' do
      subject(:contact_details_result) { result[:contact_details] }

      CONTACT_DETAILS_FIELDS.each do |field|
        it "should have the '#{field}' of the Person's ContactDetails" do
          expect(contact_details_result[field]).to eq person.contact_details.send(field)
        end
      end
    end
  end

  describe 'POST create' do
    subject(:req) { post :create, format: :json, params: params }
    let(:params)  { {} }

    it_should_behave_like 'requiring a "person" param with a "name"'

    context 'with a "person" parameter with a "name"' do
      let(:params)        { { person: person_params } }
      let(:person_params) { { name: name } }
      let(:name)          { 'Subotai' }

      it { should have_http_status :created }

      it 'should create a new Person' do
        expect { req }.to change(Person, :count).by(1)
      end

      it 'should create a new ContactDetails' do
        expect { req }.to change(ContactDetails, :count).by(1)
      end

      describe 'the response body' do
        it_should_behave_like 'returning the Person and their ContactDetails' do
          let(:person) { Person.last }
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
          CONTACT_DETAILS_FIELDS.each do |field|
            it "should have a nil #{field}" do
              expect(contact_details.send(field)).to be_nil
            end
          end
        end

        context 'if all the ContactDetails fields were passed as the "contact_details" of the ' \
          'person' do
          let(:person_params)          { super().merge contact_details: contact_details_params }
          let(:contact_details_params) { CONTACT_DETAILS_FIELDS.map { |f| [f, f.to_s] }.to_h }

          CONTACT_DETAILS_FIELDS.each do |field|
            it "should have the specified #{field}" do
              expect(contact_details.send(field)).to eq contact_details_params[field]
            end
          end
        end
      end
    end
  end

  describe 'PUT update' do
    subject(:req) { put :update, params: params }
    let(:person_id) { -11 }
    let(:params)    { { id: person_id } }

    it_should_behave_like 'requiring a "person" param with a "name"'

    context 'with a "person" parameter with a "name"' do
      let(:params)        { super().merge(person: person_params) }
      let(:person_params) { { name: name } }
      let(:name)          { 'Sigmund Freud' }

      context 'if there is no Person with the specified id' do
        it_should_behave_like(
          'an API error', message: /person found/i, key: 'not_found', status: :not_found
        )
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
          it_should_behave_like 'returning the Person and their ContactDetails' do
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
              CONTACT_DETAILS_FIELDS.each do |field|
                it "should not have its #{field} changed" do
                  expect { req }.not_to change { contact_details.reload.send(field) }
                end
              end
            end

            context 'if all the ContactDetails fields were passed as the "contact_details" of the' \
              ' person' do
              let(:person_params)          { super().merge contact_details: contact_details_params }
              let(:contact_details_params) { CONTACT_DETAILS_FIELDS.map { |f| [f, f.to_s] }.to_h }

              CONTACT_DETAILS_FIELDS.each do |field|
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
    subject(:req)   { delete :destroy, params: { id: person_id } }
    let(:person_id) { -1 }

    context 'if there is no Person with the specified id' do
      it_should_behave_like(
        'an API error', message: /person found/i, key: 'not_found', status: :not_found
      )
    end

    context 'if the Person does exist' do
      let!(:person)   { FactoryGirl.create :person }
      let(:person_id) { person.id }

      it { should have_http_status :ok }

      it 'should delete the Person' do
        expect { req }.to change { Person.find_by(id: person_id) }.to nil
      end

      describe 'the response body' do
        it_should_behave_like 'returning the Person and their ContactDetails'
      end
    end
  end
end
