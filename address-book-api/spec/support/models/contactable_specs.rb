module ContactableSpecs
  extend ActiveSupport::Concern

  included do
    shared_examples_for 'a model with ContactDetails' do
      %i(name contact_details_id).each do |field|
        it { should have_db_column(field).with_options(null: false) }
      end

      it { should have_db_index(:contact_details_id).unique }
      it { should have_db_index(:name) }

      it { should belong_to :contact_details }

      it { should validate_presence_of :name }
      it { should validate_presence_of :contact_details }

      it 'should not be possible to share ContactDetails' do
        first_contactable = FactoryGirl.create factory_name
        second_contactable = FactoryGirl.create factory_name
        second_contactable.contact_details = first_contactable.contact_details
        expect(second_contactable.save).to be_falsy
      end
    end
  end
end
