class Copy

  def initialize(list, id)
    @list = list
    @id = id
    @user = User.find(id)
  end

  def copy
    @list_copy = @list.dup
    @list_copy.save!
    new_name = "#{@list.name}_fork"
    i = 0
    while List.where(name: new_name).count > 0
      i += 1
      new_name = "#{@list.name}_fork_#{i}"
    end
    @list_copy.name = new_name

    @list_copy_id = @list_copy.id



    @list.quantities.each do |q|
      q.dup.update_attribute(:list_id, @list_copy_id)
    end

    @list.posts.each do |p|
      new_post = p.dup
      new_post.update_attributes!(:original_author => @list.user.id, :list_id => @list_copy_id, :user_id => @id, :parent_dish => p.id)
      p.images.each do |i|
        i.dup.update_attribute(:post_id,new_post.id)
      end
    end

   
    user_settings = @user.settings 

    age = user_settings["age"].to_i
    if age == 0
      age = 30
    end
    gender = user_settings["sex"]
    if gender == nil || gender == ""
      gender = "f"
    end
    store = "Peapod"
    percentage = @list_copy.percentage

    min_calories = user_settings["min_calories"].to_i
    max_calories =  user_settings["max_calories"].to_i
    if user_settings["carbohydrates"] == nil || user_settings["carbohydrates"] == ""
      carbohydrates_percentage = -1
    else
      carbohydrates_percentage = user_settings["carbohydrates"].to_i
    end
    if user_settings["fat"] == nil || user_settings["fat"] == "" 
      fat_percentage = -1
    else
      fat_percentage = user_settings["fat"].to_i
    end
    if user_settings["protein"] == nil || user_settings["protein"] == "" 
      protein_percentage = -1
    else
      protein_percentage = user_settings["protein"].to_i
    end

    if carbohydrates_percentage == -1
      min_carbohydrates = ((min_calories.to_f/4)*0.1).round
      max_carbohydrates = ((max_calories.to_f/4)*0.9).round
    else
      min_calories_from_carbohydrates = carbohydrates_percentage * 0.01 * min_calories - 100
      max_calories_from_carbohydrates = carbohydrates_percentage * 0.01 * max_calories + 100
      min_carbohydrates = (min_calories_from_carbohydrates/4).to_i
      max_carbohydrates = (max_calories_from_carbohydrates/4).to_i
    end
    if fat_percentage == -1
      min_fat = ((min_calories.to_f/9)*0.1).round
      max_fat = ((max_calories.to_f/9)*0.9).round
    else
      min_calories_from_fat = fat_percentage * 0.01 * min_calories - 100
      max_calories_from_fat = fat_percentage * 0.01 * max_calories + 100
      min_fat = (min_calories_from_fat/9).to_i
      max_fat = (max_calories_from_fat/9).to_i
    end
    if protein_percentage == -1
      min_protein = (user_settings["weight"].to_i*0.25).round
      max_protein = (user_settings["weight"].to_i*0.50).round
    else
      min_calories_from_protein = protein_percentage * 0.01 * min_calories - 100
      max_calories_from_protein = protein_percentage * 0.01 * max_calories + 100
      min_protein = (min_calories_from_protein/4).to_i
      max_protein = (max_calories_from_protein/4).to_i
    end

    min_fiber = user_settings["min_fiber"].to_i
    min_potassium =  1
    min_vitamin_a = user_settings["min_vitamin_a"].to_i
    min_vitamin_c = user_settings["min_vitamin_c"].to_i
    min_iron = user_settings["min_iron"].to_i
    min_calcium = user_settings["min_calcium"].to_i
    max_sodium = user_settings["max_sodium"].to_i
    max_sugar = 500
    vegetarian = user_settings["vegetarian"]
    pescatarian = user_settings["pescatarian"]
    red_meat_free = user_settings["red_meat_free"]
    dairy_free = user_settings["dairy_free"]
    peanut_free = user_settings["peanut_free"]
    gluten_free = user_settings["gluten_free"]
    egg_free = user_settings["egg_free"]
    kosher = user_settings["kosher"]
    store_brand = user_settings["store_brand"]
    organic = user_settings["organic"]
    soy_free = user_settings["soy_free"]
    unprocessed = user_settings["unprocessed"]
    custom = user_settings["custom"]
    height = user_settings["height"]
    weight = user_settings["weight"]
    activity_level = user_settings["activity_level"]
    if age.to_i < 4
      max_vitamin_a = (75 * percentage * 0.01).round
      max_vitamin_c = (667 * percentage * 0.01).round
      max_calcium = (250 * percentage * 0.01).round
      max_iron = (222 * percentage * 0.01).round
    elsif age.to_i < 9
      max_vitamin_a = (112 * percentage * 0.01).round
      max_vitamin_c = (1080 * percentage * 0.01).round
      max_calcium = (250 * percentage * 0.01).round
      max_iron = (222 * percentage * 0.01).round
    elsif age.to_i < 14
      max_vitamin_a = (212 * percentage * 0.01).round
      max_vitamin_c = (1200 * percentage * 0.01).round
      max_calcium = (300 * percentage * 0.01).round
      max_iron = (222 * percentage * 0.01).round
    elsif age.to_i < 19
      max_vitamin_a = (350 * percentage * 0.01).round
      max_vitamin_c = (2000 * percentage * 0.01).round
      max_calcium = (300 * percentage * 0.01).round
      max_iron = (250 * percentage * 0.01).round
    elsif age.to_i < 51
      max_vitamin_a = (375 * percentage * 0.01).round 
      max_vitamin_c = (3333 * percentage * 0.01).round 
      max_calcium = (250 * percentage * 0.01).round 
      max_iron = (250 * percentage * 0.01).round 
    else
      max_vitamin_a = (375 * percentage * 0.01).round 
      max_vitamin_c = (3333 * percentage * 0.01).round 
      max_calcium = (200 * percentage * 0.01).round 
      max_iron = (250 * percentage * 0.01).round 
    end

    the_string = ""

    if vegetarian == "1"
      the_string << "meat = 0 AND "
    elsif pescatarian == "1"
      the_string << "(meat = 0 OR meat = 2) AND "
    elsif red_meat_free == "1"
      the_string << "(meat = 0 OR meat = 1 OR meat = 2) AND "
    end
    if dairy_free == "1"
      the_string << "dairy_free = 1 AND "
    end
    if peanut_free == "1"
      the_string << "peanut_free = 1 AND "
    end
    if gluten_free == "1"
      the_string << "gluten_free = 1 AND "
    end
    if egg_free == "1"
      the_string << "egg_free = 1 AND "
    end

    if store_brand == "1"
      the_string << "store_brand = 1 AND "
    end
    if organic == "1"
      the_string << "organic = 1 AND "
    end
    if soy_free == "1"
      the_string << "soy_free = 1 AND "
    end
    if unprocessed == "1"
      the_string << "unprocessed = 1 AND "
    end
    added_sugar = ["nectar","corn starch","syrup","sugar","sweet","honey","fruit juice","concentrate","dextrose", "fructose", "glucose", "lactose", "maltose", "sucrose"]
    if custom != nil && custom != ""
      custom_array = custom.split(",").map(&:strip) + added_sugar
    else
      custom_array = added_sugar
    end
    add = custom_array.map {|i| "%"+i+"%"}
    prepare = "#{add}".gsub("\"","\'")
    the_string << "ingredients NOT ILIKE ALL ( array"+prepare+" ) AND "



    @list_copy.update_attributes!(:user_id => @id, 
                                  :hard_delete => "", 
                                  :hard_add => "",
                                  :gender => gender,
                                  :age => age)


    @list_copy.nutrition_constraints["min_calories"] = min_calories
    @list_copy.nutrition_constraints["max_calories"] = max_calories
    @list_copy.nutrition_constraints["carbohydrates"] = carbohydrates_percentage.to_s
    @list_copy.nutrition_constraints["fat"] = fat_percentage.to_s
    @list_copy.nutrition_constraints["protein"] = protein_percentage.to_s
    @list_copy.nutrition_constraints["min_carbohydrates"] = min_carbohydrates
    @list_copy.nutrition_constraints["max_carbohydrates"] = max_carbohydrates
    @list_copy.nutrition_constraints["min_fat"] = min_fat
    @list_copy.nutrition_constraints["max_fat"] = max_fat
    @list_copy.nutrition_constraints["min_protein"] = min_protein
    @list_copy.nutrition_constraints["max_protein"] = max_protein
    @list_copy.nutrition_constraints["min_fiber"] = min_fiber
    @list_copy.nutrition_constraints["min_potassium"] = min_potassium
    @list_copy.nutrition_constraints["min_vitamin_a"] = min_vitamin_a
    @list_copy.nutrition_constraints["max_vitamin_a"] = max_vitamin_a
    @list_copy.nutrition_constraints["min_vitamin_c"] = min_vitamin_c
    @list_copy.nutrition_constraints["max_vitamin_c"] = max_vitamin_c
    @list_copy.nutrition_constraints["min_calcium"] = min_calcium
    @list_copy.nutrition_constraints["max_calcium"] = max_calcium
    @list_copy.nutrition_constraints["min_iron"] = min_iron
    @list_copy.nutrition_constraints["max_iron"] = max_iron
    @list_copy.nutrition_constraints["max_sodium"] = max_sodium
    @list_copy.nutrition_constraints["max_sugar"] = max_sugar
    @list_copy.nutrition_constraints["vegetarian"] = vegetarian
    @list_copy.nutrition_constraints["pescatarian"] = pescatarian
    @list_copy.nutrition_constraints["red_meat_free"] = red_meat_free
    @list_copy.nutrition_constraints["dairy_free"] = dairy_free
    @list_copy.nutrition_constraints["peanut_free"] = peanut_free
    @list_copy.nutrition_constraints["gluten_free"] = gluten_free
    @list_copy.nutrition_constraints["store_brand"] = store_brand
    @list_copy.nutrition_constraints["organic"] = organic
    @list_copy.nutrition_constraints["soy_free"] = soy_free
    @list_copy.nutrition_constraints["unprocessed"] = unprocessed
    @list_copy.nutrition_constraints["custom"] = custom
    @list_copy.nutrition_constraints["height"] = height
    @list_copy.nutrition_constraints["weight"] = weight
    @list_copy.nutrition_constraints["activity_level"] = activity_level
    @list_copy.nutrition_constraints["dietary_restrictions"] = the_string
    @list_copy.save!
    @list_copy_id

  end
end