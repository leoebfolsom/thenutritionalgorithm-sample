foods = []
File.readlines('db/price_update.txt').map do |line|
  foods.push(line.split)
end

foods.each do |i|
  i = i.to_s.delete('[]""')
  i1 = i.split(",")[0].to_i
  i2 = i.split(",")[1].to_f
  Food.find(i1).update_attribute(:price, i2)
  puts "#{Food.find(i1).name}"+"#{Food.find(i1).price}"
  puts i
end