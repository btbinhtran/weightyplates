exercises_file_path = Rails.root.join("db", "exercises.json")
exercises = ActiveSupport::JSON.decode(File.read(exercises_file_path))
puts "Loading exercises..."
exercises.each do |e|
  Exercise.create!(e);
end
puts "Finished loading exercises!"