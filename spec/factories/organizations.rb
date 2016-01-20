FactoryGirl.define do
  factory :organization do |f|
    f.name 'audi'
    f.public_name 'Audi Cars'
    f.org_type 'Show Room'
    f.pricing_policy 'fixed'
  end
end