require 'csv'

#name, calories, carbohydrates, fat, protein, sugar, potassium, fiber, vitamin_a, vitamin_c, calcium, iron, sodium, price, food_store, food_store_id, aisle (size of package), meat, image, healthy, nutri (allergies, etc)

CSV.foreach("db/fast_foods.csv", {:headers=>true, :col_sep => ",", force_quotes: false, :quote_char => '"'}) do |line|
  if Food.where(id:line[0]).length == 0
    new_food = Food.create(id:line[0],name:line[1],calories:line[2],carbohydrates:line[3],fat:line[4],protein:line[5],sugar:line[6],potassium:line[7],fiber:line[8],vitamin_a:line[9],vitamin_c:line[10],calcium:line[11],iron:line[12],sodium:line[13],price:line[14],food_store:line[15],food_store_id:line[16],aisle:line[17],meat:line[18],image:line[19],healthy:line[20],nutri:line[21])
    new_food.save!
  else
    puts line[0]
  end
end