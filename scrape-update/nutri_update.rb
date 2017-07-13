foods = []
File.readlines('nutri.txt').map do |line|
  puts rand(3)
  foods.push(line.split)
end

foods.each do |i|
  i = i.to_s.delete('[]""')
  id = i.split(",")[0].to_i
  nutri = i.gsub("#{id}"+",","")
  puts id
  Food.find(id).update_attribute(:nutri, nutri)
end