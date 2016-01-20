FactoryGirl.define do
  factory :user do |f|
    f.email 'random@yopmail.com'
    f.password 'password'
    f.password_confirmation 'password'
  end
end
