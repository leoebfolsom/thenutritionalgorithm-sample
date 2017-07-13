class Macros

  def initialize(list_id)
    @list_id = list_id.to_i
  end

  def macros

    list = List.find(@list_id)
    list_days = list.days.to_i
    list_age = list.age.to_i

    carbohydrates_percentage = list.nutrition_constraints["carbohydrates"].to_i
    fat_percentage = list.nutrition_constraints["fat"].to_i
    protein_percentage = list.nutrition_constraints["protein"].to_i
    min_calories = list.nutrition_constraints["min_calories"].to_i * list_days
    max_calories =  list.nutrition_constraints["max_calories"].to_i * list_days
    if list.nutrition_constraints["min_carbohydrates"] == nil || list.nutrition_constraints["max_carbohydrates"] == nil
      if carbohydrates_percentage == -1
        min_carbohydrates = ((min_calories.to_f/4)*0.1).round
        max_carbohydrates = ((max_calories.to_f/4)*0.9).round
      else
        min_calories_from_carbohydrates = carbohydrates_percentage * 0.01 * min_calories - (100*list_days)
        max_calories_from_carbohydrates = carbohydrates_percentage * 0.01 * max_calories + (100*list_days)
        min_carbohydrates = (min_calories_from_carbohydrates/4).to_i
        max_carbohydrates = (max_calories_from_carbohydrates/4).to_i
      end
      list.nutrition_constraints["min_carbohydrates"] = min_carbohydrates
      list.nutrition_constraints["max_carbohydrates"] = max_carbohydrates
      list.save!

    end
    if list.nutrition_constraints["min_fat"] == nil || list.nutrition_constraints["max_fat"] == nil
      if fat_percentage == -1
        min_fat = ((min_calories.to_f/9)*0.1).round
        max_fat = ((max_calories.to_f/9)*0.9).round
      else
        min_calories_from_fat = fat_percentage * 0.01 * min_calories - (100*list_days)
        max_calories_from_fat = fat_percentage * 0.01 * max_calories + (100*list_days)
        min_fat = (min_calories_from_fat/9).to_i
        max_fat = (max_calories_from_fat/9).to_i
      end
      list.nutrition_constraints["min_fat"] = min_fat
      list.nutrition_constraints["max_fat"] = max_fat
      list.save!

    end
    if list.nutrition_constraints["min_protein"] == nil || list.nutrition_constraints["max_protein"] == nil
      if protein_percentage == -1
        min_protein = (list.user.settings["weight"].to_i*0.25 * list_days).round
        max_protein = (list.user.settings["weight"].to_i*0.50 * list_days).round
      else
        min_calories_from_protein = protein_percentage * 0.01 * min_calories - (100*list_days)
        max_calories_from_protein = protein_percentage * 0.01 * max_calories + (100*list_days)
        min_protein = (min_calories_from_protein/4).to_i
        max_protein = (max_calories_from_protein/4).to_i
      end
      list.nutrition_constraints["min_protein"] = min_protein
      list.nutrition_constraints["max_protein"] = max_protein
      list.save!
    end

    if list.nutrition_constraints["max_vitamin_a"] == nil || list.nutrition_constraints["max_vitamin_c"] == nil || list.nutrition_constraints["max_calcium"] == nil || list.nutrition_constraints["max_iron"] == nil

      if list_age < 4
        max_vitamin_a = 75 * list_days
        max_vitamin_c = 667 * list_days
        max_calcium = 250 * list_days
        max_iron = 222 * list_days
      elsif list_age < 9
        max_vitamin_a = 112 * list_days
        max_vitamin_c = 1080 * list_days
        max_calcium = 250 * list_days
        max_iron = 222 * list_days
      elsif list_age < 14
        max_vitamin_a = 212 * list_days
        max_vitamin_c = 1200 * list_days
        max_calcium = 300 * list_days
        max_iron = 222 * list_days
      elsif list_age < 19
        max_vitamin_a = 350 * list_days
        max_vitamin_c = 2000 * list_days
        max_calcium = 300 * list_days
        max_iron = 250 * list_days
      elsif list_age < 51
        max_vitamin_a = 375 * list_days
        max_vitamin_c = 3333 * list_days
        max_calcium = 250 * list_days
        max_iron = 250 * list_days
      else
        max_vitamin_a = 375 * list_days
        max_vitamin_c = 3333 * list_days
        max_calcium = 200 * list_days
        max_iron = 250 * list_days
      end
      list.nutrition_constraints["max_vitamin_a"] = max_vitamin_a
      list.nutrition_constraints["max_vitamin_c"] = max_vitamin_c
      list.nutrition_constraints["max_calcium"] = max_calcium
      list.nutrition_constraints["max_iron"] = max_iron
      list.save!
    end
  end

end