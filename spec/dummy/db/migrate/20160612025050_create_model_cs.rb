class CreateModelCs < ActiveRecord::Migration
  def change
    create_table :model_cs do |t|
      t.string :name

      t.timestamps
    end
  end
end
