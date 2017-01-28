class CreatePeople < ActiveRecord::Migration[5.0]

  def change
    create_table :people do |t|
      t.string :name, null: false
      t.integer :contact_details_id, null: false

      t.timestamps null: false
    end

    add_index :people, :name
    add_index :people, :contact_details_id, unique: true
  end

end
