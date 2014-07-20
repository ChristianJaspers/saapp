# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

unless Company.exists?
  company = Company.create
  team = company.teams.create

  admin_email = 'admin@example.com'
  password = '12345678'
  user = User.create_with(
    email: admin_email,
    password: password,
    password_confirmation: password,
    role: 'admin',
    team: team
  ).find_or_create_by(email: admin_email)
end
