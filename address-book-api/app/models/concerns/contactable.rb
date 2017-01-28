module Concerns
  module Contactable
    extend ActiveSupport::Concern

    included do
      belongs_to :contact_details

      validates :name, :contact_details, presence: true
      validates :contact_details, uniqueness: true

      def as_json(options = {})
        super(options.merge(only: [:name, :id])).merge(contact_details: contact_details.as_json)
      end
    end
  end
end
