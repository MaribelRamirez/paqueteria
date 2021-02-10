class CreateEnvios < ActiveRecord::Migration
  def change
    create_table :envios do |t|
      t.string :name
      t.integer :guide_number
      t.string :status
      t.string :description

      t.timestamps null: false
    end
  end
end
