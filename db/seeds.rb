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
    { key: 'ctf_name', value: 'CTF' },
    { key: 'ctf_logo', value: '/logo.svg' },
    { key: 'team_size', value: '4' },
    { key: 'flag_regex', value: 'flag{[A-Za-z0-9_\-]+}' }
  ]
}
defaults[:settings].each do |setting|
  CtfSetting.find_or_create_by(setting)
end

defaults[:users].each do |user|
  User.create!(user) unless User.find_by(email: user[:email])
end
