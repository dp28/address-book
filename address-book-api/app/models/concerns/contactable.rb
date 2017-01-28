module Concerns
  module Contactable
    extend ActiveSupport::Concern

    included do
      belongs_to :contact_details

      validates :name, :contact_details, presence: true
      validates :contact_details, uniqueness: true
    end
  end
end
