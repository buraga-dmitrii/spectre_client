FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password 'password'
    password_confirmation "password"
  end
  factory :invalid_user, class: 'User' do
    email nil
    password 'password'
    password_confirmation "password"
    confirmed_at Date.today    
  end
end
