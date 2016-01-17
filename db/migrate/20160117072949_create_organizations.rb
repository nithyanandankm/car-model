class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string :name
      t.string :public_name
      t.string :org_type, limit: 10
      t.string :pricing_policy, limit: 10

      t.timestamps null: false
    end
  end
end
