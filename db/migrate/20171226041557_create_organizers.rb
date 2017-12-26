class CreateOrganizers < ActiveRecord::Migration[5.0]
  def change
    create_table :organizers do |t|
      t.reference :User

      t.timestamps
    end
  end
end
