exercises_file_path = Rails.root.join("db", "exercises.json")
exercises = ActiveSupport::JSON.decode(File.read(exercises_file_path))
puts exercises.size