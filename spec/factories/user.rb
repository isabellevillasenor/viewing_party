FactoryBot.define do
  factory :user do
    name { Faker::Name.first_name }
    email { Faker::Internet.email }
    password { Faker::Internet.password }

    factory :friend do
      transient { user { create(:user) } }

      after(:create) do |friend, transient|
        transient.user.friends << friend
      end
    end
  end
end
