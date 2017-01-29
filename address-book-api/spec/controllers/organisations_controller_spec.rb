require 'rails_helper'

RSpec.describe OrganisationsController, type: :controller do
  include ContactableResultSpecs

  describe 'GET index' do
    subject(:req) { get :index, params: params }
    let(:params)  { {} }

    it { should have_http_status :ok }

    context 'if there are no Organisations' do
      it 'should return an empty array' do
        expect(result).to eq []
      end
    end

    context 'if there are Organisations' do
      let!(:organisations) { FactoryGirl.create_list :organisation, 2 }
      let(:returned_names) { result.map { |organisation| organisation[:name] } }

      it 'should have a result for each organisation' do
        expect(result.size).to eq organisations.size
      end

      it 'should return the organisations sorted by name' do
        expect(returned_names).to eq organisations.map(&:name).sort
      end

      describe 'the result for each Organisation' do
        it_should_behave_like 'returning the Contactable and their ContactDetails' do
          let(:contactable)        { organisations.sort_by(&:name).first }
          let(:contactable_result) { result.first }
        end
      end

      describe 'when a "matching_name" param is passed' do
        let(:params)        { { matching_name: matching_name } }
        let(:matching_name) { 'crate' }

        it 'should only return the organisations with names that include the provided substring' do
          organisations.first.update name: 'Socrates'
          organisations.second.update name: 'Joan of Arc'
          expect(returned_names).to eq ['Socrates']
        end
      end
    end
  end

  describe 'POST create' do
    subject(:req) { post :create, format: :json, params: params }
    let(:params)  { {} }

    it_should_behave_like 'requiring a contactable param', :organisation

    context 'with a "organisation" parameter with a "name"' do
      let(:params)              { { organisation: organisation_params } }
      let(:organisation_params) { { name: name } }
      let(:name)                { 'The French Army' }

      it { should have_http_status :created }

      it 'should create a new Organisation' do
        expect { req }.to change(Organisation, :count).by(1)
      end

      it 'should create a new ContactDetails' do
        expect { req }.to change(ContactDetails, :count).by(1)
      end

      describe 'the response body' do
        it_should_behave_like 'returning the Contactable and their ContactDetails' do
          let(:contactable)        { Organisation.last }
          let(:contactable_result) { result }
        end
      end

      describe 'the new Organisation' do
        subject(:organisation) { Organisation.last }
        before { req }

        it 'should have the supplied name' do
          expect(organisation.name).to eq name
        end

        it 'should have the new ContactDetails' do
          expect(organisation.contact_details).to eq ContactDetails.last
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
          'organisation' do
          let(:organisation_params)    { super().merge contact_details: contact_details_params }
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
    subject(:req)         { put :update, params: params }
    let(:organisation_id) { -11 }
    let(:params)          { { id: organisation_id } }

    it_should_behave_like 'requiring a contactable param', :organisation

    context 'with a "organisation" parameter with a "name"' do
      let(:params)              { super().merge(organisation: organisation_params) }
      let(:organisation_params) { { name: name } }
      let(:name)                { 'Sigmund Freud' }

      context 'if there is no Organisation with the specified id' do
        it_should_behave_like 'a not found response', 'organisation'
      end

      context 'if there is a Organisation with the specified id' do
        let!(:organisation)   { FactoryGirl.create :organisation }
        let(:organisation_id) { organisation.id }

        it { should have_http_status :ok }

        it 'should not create a new Organisation' do
          expect { req }.not_to change(Organisation, :count)
        end

        it 'should not create a new ContactDetails' do
          expect { req }.not_to change(ContactDetails, :count)
        end

        describe 'the response body' do
          it_should_behave_like 'returning the Contactable and their ContactDetails' do
            let(:contactable)        { organisation }
            let(:contactable_result) { result }

            before do
              req
              organisation.reload
            end
          end
        end

        describe 'the stored Organisation' do
          it 'should have its name changed to the supplied name' do
            expect { req }.to change { organisation.reload.name }.to name
          end

          describe 'the Organisation\'s ContactDetails' do
            let(:contact_details) { ContactDetails.last }

            context 'if no contact details were passed' do
              ContactDetails::USER_EDITABLE_PARAMS.each do |field|
                it "should not have its #{field} changed" do
                  expect { req }.not_to change { contact_details.reload.send(field) }
                end
              end
            end

            context 'if all the ContactDetails fields were passed as the "contact_details" of the' \
              ' organisation' do
              let(:organisation_params)    { super().merge contact_details: contact_details_params }
              let(:contact_details_params) { fully_specified_contact_details_params }

              ContactDetails::USER_EDITABLE_PARAMS.each do |field|
                it "should have the specified #{field} changed to the passed in value" do
                  expect { req }.to \
                    change { organisation.reload.contact_details.send(field) }
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
    subject(:req) { delete :destroy, params: { id: organisation_id } }
    let(:organisation_id) { -1 }

    context 'if there is no Organisation with the specified id' do
      it_should_behave_like 'a not found response', 'organisation'
    end

    context 'if the Organisation does exist' do
      let!(:organisation)   { FactoryGirl.create :organisation }
      let(:organisation_id) { organisation.id }

      it { should have_http_status :ok }

      it 'should delete the Organisation' do
        expect { req }.to change { Organisation.find_by(id: organisation_id) }.to nil
      end

      describe 'the response body' do
        it_should_behave_like 'returning the Contactable and their ContactDetails' do
          let(:contactable)        { organisation }
          let(:contactable_result) { result }
        end
      end
    end
  end
end
