foods = []
File.readlines('db/fish.txt').map do |line|
  foods.push(line.split)
end

foods.each do |i|
  i = i.to_s.delete('[]""')
  i1 = i.split(",")[0].to_i
  Food.find(i1).update_attribute(:meat, 2)
end