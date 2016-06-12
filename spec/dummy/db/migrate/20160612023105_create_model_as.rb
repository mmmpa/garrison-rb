class CreateModelAs < ActiveRecord::Migration
  def change
    create_table :model_as do |t|
      t.string :name

      t.timestamps
    end
  end
end
