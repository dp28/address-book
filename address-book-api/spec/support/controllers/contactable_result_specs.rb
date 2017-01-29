require_relative './has_json_result'
require_relative './error_specs'

module ContactableResultSpecs
  extend ActiveSupport::Concern
  include HasJsonResult
  include ErrorSpecs

  included do
    let(:fully_specified_contact_details_params) do
      ContactDetails::USER_EDITABLE_PARAMS.map { |field| [field, field.to_s] }.to_h
    end

    shared_examples_for 'requiring a contactable param' do |contactable_type|
      context "without a '#{contactable_type}' parameter" do
        it_should_behave_like 'requiring a parameter', contactable_type
      end

      context "with a '#{contactable_type}' parameter" do
        let(:params)             { super().merge(contactable_type => contactable_params) }
        let(:contactable_params) { {} }

        context 'without a "name" parameter' do
          it_should_behave_like 'requiring a parameter', "#{contactable_type}.name"
        end
      end
    end

    shared_examples_for 'returning the Contactable and their ContactDetails' do
      subject { contactable_result }

      it 'should have the specified name' do
        expect(contactable_result[:name]).to eq contactable.name
      end

      it 'should have the id of the new Contactable' do
        expect(contactable_result[:id]).to eq contactable.id
      end

      it 'should have a "contact_details" object' do
        expect(contactable_result).to have_key :contact_details
      end

      describe 'the "contact_details" object' do
        subject(:contact_details_result) { contactable_result[:contact_details] }

        ContactDetails::USER_EDITABLE_PARAMS.each do |field|
          it "should have the '#{field}' of the Contactable's ContactDetails" do
            expect(contact_details_result[field]).to eq contactable.contact_details.send(field)
          end
        end
      end
    end
  end
end
