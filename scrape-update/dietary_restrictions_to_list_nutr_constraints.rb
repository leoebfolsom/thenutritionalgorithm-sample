lists = List.all
lists.each do |l|
  nutrition_constraints = l.nutrition_constraints
  the_string = ""

  if nutrition_constraints["vegetarian"] == "1"
    the_string << "meat = 0 AND "
  elsif nutrition_constraints["pescatarian"] == "1"
    the_string << "(meat = 0 OR meat = 2) AND "
  elsif nutrition_constraints["red_meat_free"] == "1"
    the_string << "(meat = 0 OR meat = 1 OR meat = 2) AND "
  end
  if nutrition_constraints["dairy_free"] == "1"
    the_string << "dairy_free = 1 AND "
  end
  if nutrition_constraints["peanut_free"] == "1"
    the_string << "peanut_free = 1 AND "
  end
  if nutrition_constraints["gluten_free"] == "1"
    the_string << "gluten_free = 1 AND "
  end
  if nutrition_constraints["egg_free"] == "1"
    the_string << "egg_free = 1 AND "
  end
  if nutrition_constraints["kosher"] == "1"
    the_string << "kosher = 1 AND "
  end
  if nutrition_constraints["store_brand"] == "1"
    the_string << "store_brand = 1 AND "
  end
  if nutrition_constraints["organic"] == "1"
    the_string << "organic = 1 AND "
  end
  if nutrition_constraints["soy_free"] == "1"
    the_string << "soy_free = 1 AND "
  end
  if nutrition_constraints["unprocessed"] == "1"
    the_string << "unprocessed = 1 AND "
  end

  added_sugar = ["nectar","corn starch","syrup","sugar","sweet","honey","fruit juice","concentrate","dextrose", "fructose", "glucose", "lactose", "maltose", "sucrose"]

  if nutrition_constraints["custom"] != nil && nutrition_constraints["custom"] != ""
    custom = nutrition_constraints["custom"].split(",").map(&:strip) + added_sugar
  else
    custom = added_sugar
  end
  add = custom.map {|i| "%"+i+"%"}
  prepare = "#{add}".gsub("\"","\'")
  the_string << "ingredients NOT ILIKE ALL ( array"+prepare+" ) AND "

  l.nutrition_constraints["dietary_restrictions"] = the_string



  l.save!  
end