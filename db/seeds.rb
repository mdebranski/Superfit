# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'csv'

props = YAML.load(File.read(File.join(Rails.root, 'config', 'database.yml')))[Rails.env]
props[:adapter] = :postgres # Sequel requires postgres instead of postgresql
DB = Sequel.connect(props)

scoring_method_map = {"For Time" => 'for_time', "Pass/Fail" => 'pass_fail', "AMRAP  (rounds)" => 'rounds', "For time" => 'for_time', "Max Reps" => 'max_reps' }

wods = DB[:wods]
wods.truncate()
CSV.foreach(File.join(Rails.root, 'db', 'wods.csv'), :headers => :first_row) do |row|
  row['scoring_method'] = scoring_method_map[row['scoring_method']]
  wods.insert(row.to_hash)
end