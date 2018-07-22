# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name 'Sherlock Holmes'
    email 'sherlock_holmes@21baker.street'
    username 'sherlock_holmes'
    password 'sher123'
    password_confirmation 'sher123'
    team
  end

  factory :team do
    name 'SomeRandomTeam'
  end

  factory :session do
    user
    ip_address '192.168.1.1'
    browser 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_4) '\
      'AppleWebKit/537.36 (KHTML, like Gecko) Chrome/67.0.3396.87 Safari/537.36'
  end

  factory :category do
    name 'web'
  end

  factory :challenge do
    title 'SQLi baby'
    category
    description 'you need the flag'
    link 'sqli.baby'
    flag 'flag{5QL1_15_AWES0ME}'
    points 100
    max_tries 100
    active true
  end

  factory :flag_regex, class: CtfSetting do
    key 'flag_regex'
    value 'flag{[A-Za-z0-9_]+}'
  end
end
