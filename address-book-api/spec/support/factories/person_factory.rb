FactoryGirl.define do
  sequence(:person_name) { |i| "Genghis Khan the #{i.ordinalize}" }
  factory :person do
    name { generate(:person_name) }
    contact_details
  end
end
