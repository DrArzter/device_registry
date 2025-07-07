# frozen_string_literal: true

FactoryBot.define do
  factory :device do
    sequence(:serial_number) { |n| "SN-#{SecureRandom.hex(4).upcase}-#{n}" }
  end
end
