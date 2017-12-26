class CreateOrganizers < ActiveRecord::Migration[5.0]
  def change
    create_table :organizers do |t|
      t.references :User, foreign_key: true

      t.timestamps
    end
  end
end
