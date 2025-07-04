FactoryBot.define do
    factory :device_assignment do
        
        association :user
        association :device

        active { true }
        returned_at { nil }

        trait :returned do
            active { false }
            returned_at { Time.current }
        end
    end
end