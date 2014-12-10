    factory :normal do
      after(:create) do |user|
        user.grant :normal
      end
    end

    factory :admin do
      after(:create) do |user|
        user.grant :normal
        user.grant :admin
      end
    end

    factory :system do
      after(:create) do |user|
        user.grant :normal
        user.grant :system
      end
    end
