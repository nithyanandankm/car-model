class CreateModelTypes < ActiveRecord::Migration
  def change
    create_table :model_types do |t|
      t.references :model
      t.string :name
      t.string :model_type_slug
      t.string :model_type_code
      t.string :string
      t.integer :base_price

      t.timestamps null: false
    end
  end
end
