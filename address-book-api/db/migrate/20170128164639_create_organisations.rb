class CreateOrganisations < ActiveRecord::Migration[5.0]
  def change
    create_table :organisations do |t|
      t.string :name, null: false
      t.integer :contact_details_id, null: false

      t.timestamps null: false
    end

    add_index :organisations, :name
    add_index :organisations, :contact_details_id, unique: true
  end
end
