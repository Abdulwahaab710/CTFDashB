class CreateCaptureTheFlags < ActiveRecord::Migration[5.0]
  def change
    create_table :capture_the_flags do |t|
      t.string :name
      t.string :info
      t.number :max_teammates

      t.timestamps
    end
  end
end
