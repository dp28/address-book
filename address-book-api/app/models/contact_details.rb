class ContactDetails < ApplicationRecord
  USER_EDITABLE_PARAMS = %i(
    street_address additional_street_address city county country postcode email phone_number
  ).freeze

  def as_json(options = {})
    super options.merge(only: USER_EDITABLE_PARAMS)
  end
end
