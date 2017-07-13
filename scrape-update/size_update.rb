require 'csv'
#foods = []
#valid_foods = []
CSV.foreach("db/sizes.csv", {:headers=>false, :col_sep => ",", force_quotes: false, :quote_char => '"'}) do |line|
  Food.find(line[0]).update_attribute(:aisle, line[2])
end
#File.readlines('scr/valid_food_id_temp.txt').map do |line|
#  valid_foods.push(line.split.to_s.delete('[]""'))
#end
#puts valid_foods - foods





#foods.first.each do |i|
#  i.to_s.delete('[]""')
 # i = i.to_s.delete('[]""')
 # i1 = i.split(",")[0].to_i
 # i2 = i.split(",")[1]
 # i3 = i.split(",")[2]
  #Food.find(i1).update_attribute(:meat, 2)
#  puts i
 # puts i1
 # puts i2
 # puts i3
#end