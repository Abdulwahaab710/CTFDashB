# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
defaults = {
  users: [
    {
      name: 'User name',
      username: 'admin',
      email: 'admin@admin.com',
      password: 'changeme',
      password_confirmation: 'changeme',
      admin: true,
      organizer: true
    }
  ],
  settings: [
    { key: 'ctf_name', value_type: 'String', value: 'CTF' },
    { key: 'ctf_logo', value_type: 'String', value: '/logo.svg' },
    { key: 'team_size', value_type: 'String', value: '4' },
    { key: 'flag_regex', value_type: 'String', value: 'flag{[A-Za-z0-9_\-]+}' },
    { key: 'start_time', value_type: 'Time', value: Time.zone.now },
    { key: 'end_time', value_type: 'Time', value: '' },
    { key: 'hash_flag', value_type: 'Boolean', value: 'false' },
    { key: 'scoreboard', value_type: 'Boolean', value: 'true' },
    { key: 'unlimited_retries', value_type: 'Boolean', value: 'false' },
    { key: 'default_max_tries', value_type: 'String', value: '100' },
    { key: 'general_submission', value_type: 'Boolean', value: 'true' }
  ]
}
defaults[:settings].each do |setting|
  CtfSetting.find_or_create_by(setting)
end

unless User.count > 0
  defaults[:users].each do |user|
    User.create!(user) unless User.find_by(email: user[:email])
  end
end

if Rails.env.development? && Category.count < 10
  user = User.first
  (1..10).each do |n|
    description = "Enim molestiae incidunt rem ipsum perferendis beatae excepturi tenetur."
    category = Category.create!(name: "Category-#{n}", description: description)
    (1..10).each do |i|
      Challenge.create!(
        title: "Challenge-#{n}-#{i}",
        points: (n * i),
        max_tries: n.to_i,
        flag: "flag{flag-#{n}-#{i}}",
        category: category,
        user: user
      )
    end
  end
end
