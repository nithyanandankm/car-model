# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


user_data = {
  email: 'ola@yopmail.com',
  password: 'password',
  password_confirmation: 'password',
  sign_in_count: 0
}

api_key_data = {
  name: 'Default Key',
  access_token: '38ba9140af000ba7b9fc80c3c46267d1'
}

organizations = [
  {
    name: 'honda',
    public_name: 'New Honda',
    org_type: 'Show room',
    pricing_policy: 'Flexible',
    models: [
      { name: 'Accord', model_slug: 'accord',
        model_types: [
          {name: 'Basic Model', model_type_slug: 'base-1', model_type_code: 'B01', base_price: 20000},
          {name: 'Economic', model_type_slug: 'eco-1', model_type_code: 'E01', base_price: 30000},
          {name: 'Top end', model_type_slug: 'top-1', model_type_code: 'T01', base_price: 40000}
        ]
      }
    ]
  },
  {
    name: 'ford',
    public_name: 'Ford Motor Services',
    org_type: 'Service',
    pricing_policy: 'Fixed',
    models: [
      { name: 'Fiesta', model_slug: 'fiesta',
        model_types: [
          {name: 'Fiesta Basic', model_type_slug: 'fb-1', model_type_code: 'FB01', base_price: 20000},
          {name: 'Fiesta Economic', model_type_slug: 'fe-1', model_type_code: 'FE01', base_price: 30000},
          {name: 'Fiesta Flair', model_type_slug: 'ff-1', model_type_code: 'FF01', base_price: 40000}
        ]
      }
    ]
  },
  {
    name: 'toyota',
    public_name: 'Toyota Cars',
    org_type: 'Dealer',
    pricing_policy: 'Prestige',
    models: [
      { name: 'Etios', model_slug: 'etios',
        model_types: [
          {name: 'Etios V1', model_type_slug: 'ev-1', model_type_code: 'EV01', base_price: 20000},
          {name: 'Etios V2', model_type_slug: 'ev-2', model_type_code: 'EV02', base_price: 30000},
          {name: 'Etios V3', model_type_slug: 'ev-3', model_type_code: 'EV03', base_price: 40000}
        ]
      }
    ]
  }
]

user = User.create(user_data)
ApiKey.create(api_key_data.merge(user_id: user.id))
organizations.each do |org_seed|
  org_data = org_seed.select { |k, v| %w(name public_name org_type pricing_policy).include?(k.to_s)}
  org = Organization.create(org_data.merge(user_id: user.id))
  org_seed[:models].each do |model_seed|
    model_data = model_seed.select { |k, v| %w(name model_slug).include?(k.to_s)}
    model = Model.create(model_data.merge(organization_id: org.id))
    model_seed[:model_types].each do |model_type_seed|
      ModelType.create(model_type_seed.merge(model_id: model.id))
    end
  end
end