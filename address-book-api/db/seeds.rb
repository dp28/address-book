# This file should contain all the record creation needed to seed the database with its default
# values. The data can then be loaded with the rails db:seed command (or created alongside the
# database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
organisation_details = ContactDetails.create(
  email:    'old_timers@example.com',
  country:  'UK',
  postcode: 'AB1 2CD'
)

organisation = Organisation.create name: 'Historical figures', contact_details: organisation_details

[
  'Genghis Khan',
  'Sigmund Freud',
  'Napoleon Bonaparte',
  'Beethoven',
  'Billy the Kid',
  'Socrates',
  'Abraham Lincoln',
  'Joan of Arc'
].each do |name|
  details = ContactDetails.create(
    email:          "#{name}@example.com",
    phone_number:   '8675309',
    street_address: '123 Fake Street',
    country:        'UK',
    postcode:       'AB1 2CD'
  )

  Person.create(name: name, contact_details: details)
end

organisation.people << Person.first(3)
