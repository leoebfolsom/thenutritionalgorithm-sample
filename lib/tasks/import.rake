#lib/tasks/import.rake
require 'csv'
desc "Imports a CSV file into an ActiveRecord table"
task :import, [:filename] => :environment do    
    CSV.foreach('db/rake.csv', :headers => true) do |row|
      Food.create!(row.to_hash)
    end
end