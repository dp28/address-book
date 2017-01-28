class CreateContactDetails < ActiveRecord::Migration[5.0]

  def change
    create_table :contact_details do |t|
      t.string :email
      t.string :phone_number
      t.string :street_address
      t.string :additional_street_address
      t.string :city
      t.string :county
      t.string :country
      t.string :postcode

      t.timestamps null: false
    end
  end

end
