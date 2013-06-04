# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'csv'

if ENV['DATABASE_URL']
  DB = Sequel.connect(ENV['DATABASE_URL'])
else
  props = YAML.load(File.read(File.join(Rails.root, 'config', 'database.yml')))[Rails.env]
  props[:adapter] = :postgres # Sequel requires postgres instead of postgresql
  DB = Sequel.connect(props)
end

Gym.destroy_all()
CSV.foreach(File.join(Rails.root, 'db', 'gyms.csv'), :headers => :first_row) do |row|
  Gym.create!(row.to_hash)
end
