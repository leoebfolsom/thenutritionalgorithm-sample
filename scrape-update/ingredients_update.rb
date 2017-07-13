require 'csv'
all = CSV.read('scr/peapod_api_updated_info.csv')
all.each do |a|
  if Food.exists?(a[0])
    Food.find(a[0]).update_attributes(:unprocessed => 1)
    puts "#{a[0]}"
  else
    puts "#{a[0]} doesn't exist}"
  end
end