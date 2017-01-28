class CreateOrganisationPeople < ActiveRecord::Migration[5.0]
  def change
    create_table :organisation_people do |t|
      t.belongs_to :person, foreign_key: true, null:false
      t.belongs_to :organisation, foreign_key: true, null:false

      t.timestamps null: false
    end

    add_index :organisation_people, [:organisation_id, :person_id], unique: true
  end
end
