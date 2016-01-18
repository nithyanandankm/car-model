class CreateModels < ActiveRecord::Migration
  def change
    create_table :models do |t|
      t.references :organization
      t.string :name
      t.string :model_slug

      t.timestamps null: false
    end
  end
end
