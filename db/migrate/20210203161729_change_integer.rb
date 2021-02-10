class ChangeInteger < ActiveRecord::Migration
  def change
    change_column :envios, :guide_number, :numeric
  end
end