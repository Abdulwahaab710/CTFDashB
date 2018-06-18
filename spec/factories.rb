# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name 'Sherlock Holmes'
    email 'sherlock_holmes@21baker.street'
    username 'sherlock_holmes'
    password 'sher123'
    password_confirmation 'sher123'
  end

  factory :session do
    user
    ip_address '192.168.1.1'
    browser 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_4) '\
      'AppleWebKit/537.36 (KHTML, like Gecko) Chrome/67.0.3396.87 Safari/537.36'
  end
end
