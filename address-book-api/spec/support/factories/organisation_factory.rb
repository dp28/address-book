FactoryGirl.define do
  sequence(:organisation_name) { |i| "The #{i.ordinalize} Khanate" }
  factory :organisation do
    name { generate(:organisation_name) }
    contact_details
  end
end
