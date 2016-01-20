class CreateApiKeys < ActiveRecord::Migration
  def change
    create_table :api_keys do |t|
      t.string :name
      t.string :access_token
      t.references :user
      t.timestamps null: false
    end
  end
end
