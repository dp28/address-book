require 'rails_helper'

RSpec.describe PeopleController, type: :controller do
  describe 'POST create' do
    subject(:req) { post :create, format: :json, params: params }
    let(:result)  { JSON.parse(req.body).deep_symbolize_keys }
    let(:params)  { {} }

    CONTACT_DETAILS_FIELDS = ContactDetails::USER_EDITABLE_PARAMS

    shared_examples_for 'requiring a parameter' do |param|
      it { should have_http_status :bad_request }

      it "should have a message stating that the '#{param}' parameter is required" do
        expect(result[:message]).to match(/#{param}.*required/)
      end

      it 'should have a key stating that a parameter is missing' do
        expect(result[:key]).to eq 'missing_parameter'
      end
    end

    context 'without a "person" parameter' do
      it_should_behave_like 'requiring a parameter', :person
    end

    context 'with a "person" parameter' do
      let(:params)        { { person: person_params } }
      let(:person_params) { {} }

      context 'without a "name" parameter' do
        it_should_behave_like 'requiring a parameter', 'person.name'
      end

      context 'with a "name" parameter' do
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
          subject { result }

          it 'should have the specified name' do
            expect(result[:name]).to eq name
          end

          it 'should have the id of the new Person' do
            expect(result[:id]).to eq Person.last.id
          end

          it 'should have a "contact_details" object' do
            expect(result).to have_key :contact_details
          end

          describe 'the "contact_details" object' do
            subject { result[:contact_details] }

            CONTACT_DETAILS_FIELDS.each do |field|
              it { should have_key field }
            end
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
  end
end
