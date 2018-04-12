# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
default_settings = [
  {key: 'ctf_name', value: 'CTF'},
  {key: 'ctf_logo', value: '/logo.png'},
  {key: 'team_size', value: '4'}
]
default_settings.each do |setting|
  CtfSetting.find_or_create_by(setting)
end
