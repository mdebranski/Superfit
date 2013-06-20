task setup: ['db:create', 'db:migrate', 'db:seed']
task resetup: ['db:drop', 'setup']

task :generate_wods_json do
  require 'csv'
  require 'active_support/all'

  scoring_method_map = {"For Time" => 'for_time', "Pass/Fail" => 'pass_fail', "AMRAP" => 'rounds', "For time" => 'for_time', "Max Reps" => 'max_reps', 'Weight / Reps / Rounds' => 'weight_reps'}

  arr = []
  count = 0
  CSV.foreach(File.join(Rails.root, 'db', 'wods.csv'), :headers => :first_row) do |row|
    row['id'] = row['id'].to_i
    original_scoring_method = row['scoring_method']
    row['scoring_method'] = scoring_method_map[original_scoring_method.strip]
    raise "ID is required" unless row['id']
    raise "No scoring method found for '#{original_scoring_method}' for WOD '#{row['name']}'" unless row['scoring_method']
    arr << row.to_hash
    count += 1
  end
  File.open(Rails.root.join('public/wods.txt'), 'w') {|f| f.write(arr.to_json)}
  puts "Wrote #{count} wods to json"
end
