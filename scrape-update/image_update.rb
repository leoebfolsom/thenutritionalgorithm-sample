foods = []
File.readlines('db/image_update.txt').map do |line|
  foods.push(line.split)
end

foods.each do |i|
  i = i.to_s.delete('[]""')
  id = i.split(",")[0].to_i
  image = i.split(",")[1].to_s
  Food.find(id).update_attribute(:image, image)
  puts id
end