require 'csv'
all = CSV.read('scr/peapod_api_updated_info.csv')
all.each do |a|
  if Food.exists?(a[0])
    Food.find(a[0]).update_attributes(:food_store_id => a[1], :root_cat_name => a[2], :sub_cat_name => a[3])
    puts "#{a[0]}"
  else
    puts "#{a[0]} doesn't exist}"
  end
end

