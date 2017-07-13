class WriteListStepwise
  require 'csv'
  
  def initialize(list,last_food_id,dont_delete_quantity_id,last_stepwise_action)
    @list = list
    @user = @list.user
    @last_food_id = last_food_id.to_i
    @dont_delete_quantity_id = dont_delete_quantity_id.to_i
    @last_stepwise_action = last_stepwise_action
  end

  def write

    list = @list
    user = @user
    list_id = list.id
    if Quantity.where(list_id:list_id).length != 0
      list = List.joins(:quantities).find(list_id)
    else
      list = List.find(list_id)
    end
    list_quantities = list.quantities
    user_favorites = user.favorites.split(",").map(&:to_i)
    total_calories = list.total_calories.to_f
    total_carbohydrates = list.total_carbohydrates.to_f
    total_fat = list.total_fat.to_f
    total_protein = list.total_protein.to_f
    total_sugar = list.total_sugar.to_f
    total_fiber = list.total_fiber.to_f
    total_vitamin_a = list.total_vitamin_a.to_f
    total_vitamin_c = list.total_vitamin_c.to_f
    total_calcium = list.total_calcium.to_f
    total_iron = list.total_iron.to_f
    total_sodium = list.total_sodium.to_f
    total_price = list.total_price.to_f
    list_store = list.store
    list_age = list.age
    budget = list.max_price.to_f
    list_days = list.days.to_f
    list_hard_delete = list.hard_delete
    list_hard_add = list.hard_add
    hard_add_quantities_ids = list_hard_add.split(",").map(&:to_i)
    hard_delete_user = user.hard_delete
    list_hard_delete += hard_delete_user
    constraints = list.nutrition_constraints
    min_calories = constraints["min_calories"].to_f * list_days
    max_calories =  constraints["max_calories"].to_f * list_days
    carbohydrates_percentage = constraints["carbohydrates"].to_f
    fat_percentage = constraints["fat"].to_f
    protein_percentage = constraints["protein"].to_f
    min_carbohydrates = constraints["min_carbohydrates"].to_f * list_days
    max_carbohydrates = constraints["max_carbohydrates"].to_f * list_days
    min_fat = constraints["min_fat"].to_f * list_days
    max_fat = constraints["max_fat"].to_f * list_days
    min_protein = constraints["min_protein"].to_f * list_days
    max_protein = constraints["max_protein"].to_f * list_days

    #status = 1
    #status_derivative = 1
    #status_check = 1

    if min_calories < 1000
      min_calories = 1.0
    end

    if max_calories < 1000
      max_calories = 1000*list_days
    end

    min_fiber = constraints["min_fiber"].to_f * list_days
    if min_fiber == 0
      min_fiber = 1.0
    end
    #    min_potassium = constraints["min_potassium"].to_i * list_days
    min_vitamin_a = constraints["min_vitamin_a"].to_f * list_days
    if min_vitamin_a == 0
      min_vitamin_a = 1.0
    end
    min_vitamin_c = constraints["min_vitamin_c"].to_f * list_days
    if min_vitamin_c == 0
      min_vitamin_c = 1.0
    end
    min_calcium = constraints["min_calcium"].to_f * list_days
    if min_calcium == 0
      min_calcium = 1.0
    end
    min_iron = constraints["min_iron"].to_f * list_days
    if min_iron == 0
      min_iron = 1.0
    end

    max_vitamin_a = constraints["max_vitamin_a"].to_f * list_days
    max_vitamin_c = constraints["max_vitamin_c"].to_f * list_days
    max_calcium = constraints["max_calcium"].to_f * list_days
    max_iron = constraints["max_iron"].to_f * list_days
    max_sodium = constraints["max_sodium"].to_f * list_days
    if max_sodium == 0
      max_sodium = 2300 * list_days
    end

    max_sugar = (max_carbohydrates/3) * list_days
    list_users = constraints["list_users"]

    if list_users != nil && list_users.length > 0

      list_users.keys.each do |l|
        min_calories += list_users[l]["min_calories"].to_f * list_days
        max_calories += list_users[l]["max_calories"].to_f * list_days
        min_carbohydrates += list_users[l]["min_carbohydrates"].to_f * list_days
        max_carbohydrates += list_users[l]["max_carbohydrates"].to_f * list_days
        min_fat += list_users[l]["min_fat"].to_f * list_days
        max_fat += list_users[l]["max_fat"].to_f * list_days
        min_protein += list_users[l]["min_protein"].to_f * list_days
        max_protein += list_users[l]["max_protein"].to_f * list_days
        min_iron += list_users[l]["min_iron"].to_f * list_days
        max_iron += list_users[l]["max_iron"].to_f * list_days
        min_calcium += list_users[l]["min_calcium"].to_f * list_days
        max_calcium += list_users[l]["max_calcium"].to_f * list_days
        min_vitamin_a += list_users[l]["min_vitamin_a"].to_f * list_days
        max_vitamin_a += list_users[l]["max_vitamin_a"].to_f * list_days
        min_vitamin_c += list_users[l]["min_vitamin_c"].to_f * list_days
        max_vitamin_c += list_users[l]["max_vitamin_c"].to_f * list_days
        max_sodium += list_users[l]["max_sodium"].to_f * list_days
        max_sugar += (list_users[l]["max_carbohydrates"].to_f/3) * list_days
        min_fiber += list_users[l]["min_fiber"].to_f * list_days
      end
    end

    if list_hard_delete != "" 
      hard_delete_foods = list_hard_delete.split(",").map(&:to_i).uniq
    else
      hard_delete_foods = []
    end

    if hard_add_quantities_ids.length != 0
      hard_add_foods = Quantity.where(id:hard_add_quantities_ids).pluck(:food_id)
    else
      hard_add_foods = []
    end
  
    #TODO: Consider whether the above logic needs to be run every time, if safe_to_add_ids is static. Does it change often?
    #TODO: Don't store in memory if not needed. Store in database or keep in memory for fast access.
    #TODO: Cache what is common to all users or static for a given user. 
    #Cache on Reddis. Don't cache it on the same server.

  #  safe_to_delete_quantities = list_quantities.where.not(food_id: hard_add_foods).pluck(:id)

    if ( total_calories > max_calories || total_calories < min_calories || 
          total_carbohydrates > max_carbohydrates || total_carbohydrates < min_carbohydrates ||
          total_fat > max_fat || total_fat < min_fat ||
          total_protein > max_protein || total_protein < min_protein ||

          total_sugar > max_sugar || 
          total_sodium > max_sodium ||
          total_vitamin_a > max_vitamin_a ||
          total_vitamin_c > max_vitamin_c ||
          total_calcium > max_calcium ||
          total_iron > max_iron ||
          total_price > budget || 

          total_vitamin_a < min_vitamin_a ||
          total_vitamin_c < min_vitamin_c ||
          total_calcium < min_calcium ||
          total_iron < min_iron ||
          total_fiber < min_fiber )
     # grand_if_began = true
      new_food = nil

      fiber_ratio = total_fiber/min_fiber;
      vitamin_a_ratio = total_vitamin_a/min_vitamin_a
      vitamin_c_ratio = total_vitamin_c/min_vitamin_c;
      calcium_ratio = total_calcium/min_calcium
      iron_ratio = total_iron/min_iron;
      raise_protein_ratio = total_protein/min_protein;
      raise_carbohydrates_ratio = total_carbohydrates/min_carbohydrates;
      raise_fat_ratio = total_fat/min_fat;
      raise_calories_ratio = total_calories/min_calories;
      
      carbohydrates_ratio = total_carbohydrates/max_carbohydrates 
      protein_ratio = total_protein/max_protein 
      fat_ratio = total_fat/max_fat 
      sodium_ratio = total_sodium/max_sodium;
      sugar_ratio = total_sugar/max_sugar;
      lower_vitamin_a_ratio = total_vitamin_a/max_vitamin_a; 
      lower_vitamin_c_ratio = total_vitamin_c/max_vitamin_c; 
      lower_calcium_ratio = total_calcium/max_calcium; 
      lower_iron_ratio = total_iron/max_iron; 
      calories_ratio = total_calories/max_calories
      price_ratio = total_price/budget;
      r = {}
      r_min = { "fiber"=>fiber_ratio,
        "vitamin_a"=>vitamin_a_ratio,
        "vitamin_c"=>vitamin_c_ratio,
        "calcium"=>calcium_ratio,
        "iron"=>iron_ratio,
        "protein"=>raise_protein_ratio,
        "fat"=>raise_fat_ratio,
        "carbohydrates"=>raise_carbohydrates_ratio,
        "calories"=>raise_calories_ratio }
      r = { "carbohydrates"=>carbohydrates_ratio,
        "fat"=>fat_ratio,
        "protein"=>protein_ratio,
        "sodium"=>sodium_ratio,
        "sugar"=>sugar_ratio,
        "vitamin_a"=>lower_vitamin_a_ratio,
        "vitamin_c"=>lower_vitamin_c_ratio,
        "calcium"=>lower_calcium_ratio,
        "iron"=>lower_iron_ratio,
        "calories"=>calories_ratio,
        "price"=>price_ratio }

      if ( total_calories < min_calories ||
              total_iron < min_iron ||
              total_fiber < min_fiber || 
              total_calcium < min_calcium || 
              total_carbohydrates < min_carbohydrates ||
              total_fat < min_fat ||
              total_protein < min_protein ||
              total_vitamin_a < min_vitamin_a ||
              total_vitamin_c < min_vitamin_c ||
              total_protein < min_protein ) &&
              total_calories < max_calories &&
              total_carbohydrates < max_carbohydrates &&
              total_fat < max_fat &&
              total_protein < max_protein &&
              total_price < budget &&
              total_sugar < max_sugar &&
              total_sodium < max_sodium &&
              total_vitamin_a < max_vitamin_a &&
              total_vitamin_c < max_vitamin_c &&
              total_iron < max_iron &&
              total_calcium < max_calcium

        calories_total_below_this_value = max_calories - total_calories
        sodium_total_below_this_value = max_sodium - total_sodium
        vitamin_a_total_below_this_value = max_vitamin_a - total_vitamin_a
        vitamin_c_total_below_this_value = max_vitamin_c - total_vitamin_c
        calcium_total_below_this_value = max_calcium - total_calcium
        iron_total_below_this_value = max_iron - total_iron
        sugar_total_below_this_value = max_sugar - total_sugar
        price_total_below_this_value = budget - total_price
        carbohydrates_total_below_this_value = max_carbohydrates - total_carbohydrates
        protein_total_below_this_value = max_protein - total_protein
        fat_total_below_this_value = max_fat - total_fat
        
        the_string = "(user_id = #{user.id} OR user_id IS NULL) AND (calories > 0 AND calories <= #{calories_total_below_this_value} AND price <= #{price_total_below_this_value} AND sodium <= #{sodium_total_below_this_value} AND vitamin_a <= #{vitamin_a_total_below_this_value} AND vitamin_c <= #{vitamin_c_total_below_this_value} AND calcium <= #{calcium_total_below_this_value} AND iron <= #{iron_total_below_this_value} AND carbohydrates <= #{carbohydrates_total_below_this_value} AND protein <= #{protein_total_below_this_value} AND fat <= #{fat_total_below_this_value}) AND "
        if constraints["dietary_restrictions"] != nil && constraints["dietary_restrictions"] != ""
          the_string << constraints["dietary_restrictions"]
        end
        empty_list_string = "healthy = 2 AND "
        empty_list_string << the_string


        if total_calories != 0
          if fiber_ratio < 1

            if fiber_ratio < lower_vitamin_a_ratio
              the_string << "fiber/#{min_fiber} > vitamin_a/#{max_vitamin_a} AND "
            end
            if fiber_ratio < lower_vitamin_c_ratio
              the_string << "fiber/#{min_fiber} > vitamin_c/#{max_vitamin_c} AND "
            end
            if fiber_ratio < lower_iron_ratio
              the_string << "fiber/#{min_fiber} > iron/#{max_iron} AND "
            end
            if fiber_ratio < lower_calcium_ratio
              the_string << "fiber/#{min_fiber} > calcium/#{max_calcium} AND "
            end
            if fiber_ratio < sodium_ratio
              the_string << "fiber/#{min_fiber} > sodium/#{max_sodium} AND "
            end
            if fiber_ratio < sugar_ratio
              the_string << "fiber/#{min_fiber} > sugar/#{max_sugar} AND "
            end
            if fiber_ratio < price_ratio
              the_string << "fiber/#{min_fiber} > price/#{budget} AND "
            end
            if fiber_ratio < calories_ratio
              the_string << "fiber/#{min_fiber} > calories/#{max_calories} AND "
            end
            if fiber_ratio < carbohydrates_ratio
              the_string << "fiber/#{min_fiber} > carbohydrates/#{max_carbohydrates} AND "
            end
            if fiber_ratio < fat_ratio
              the_string << "fiber/#{min_fiber} > fat/#{max_fat} AND "
            end
            if fiber_ratio < protein_ratio
              the_string << "fiber/#{min_fiber} > protein/#{max_protein} AND "
            end
          end

          if vitamin_a_ratio < 1
            if vitamin_a_ratio < lower_vitamin_c_ratio
              the_string << "vitamin_a/#{min_vitamin_a} > vitamin_c/#{max_vitamin_c} AND "
            end
            if vitamin_a_ratio < lower_iron_ratio
              the_string << "vitamin_a/#{min_vitamin_a} > iron/#{max_iron} AND "
            end
            if vitamin_a_ratio < lower_calcium_ratio
              the_string << "vitamin_a/#{min_vitamin_a} > calcium/#{max_calcium} AND "
            end
            if vitamin_a_ratio < sodium_ratio
              the_string << "vitamin_a/#{min_vitamin_a} > sodium/#{max_sodium} AND "
            end
            if vitamin_a_ratio < sugar_ratio
              the_string << "vitamin_a/#{min_vitamin_a} > sugar/#{max_sugar} AND "
            end
            if vitamin_a_ratio < price_ratio
              the_string << "vitamin_a/#{min_vitamin_a} > price/#{budget} AND "
            end
            if vitamin_a_ratio < calories_ratio
              the_string << "vitamin_a/#{min_vitamin_a} > calories/#{max_calories} AND "
            end
            if vitamin_a_ratio < carbohydrates_ratio
              the_string << "vitamin_a/#{min_vitamin_a} > carbohydrates/#{max_carbohydrates} AND "
            end
            if vitamin_a_ratio < fat_ratio
              the_string << "vitamin_a/#{min_vitamin_a} > fat/#{max_fat} AND "
            end
            if vitamin_a_ratio < protein_ratio
              the_string << "vitamin_a/#{min_vitamin_a} > protein/#{max_protein} AND "
            end
          end
       
          if vitamin_c_ratio < 1
            if vitamin_c_ratio < lower_vitamin_a_ratio
              the_string << "vitamin_c/#{min_vitamin_c} > vitamin_a/#{max_vitamin_a} AND "
            end
            if vitamin_c_ratio < lower_iron_ratio
              the_string << "vitamin_c/#{min_vitamin_c} > iron/#{max_iron} AND "
            end
            if vitamin_c_ratio < lower_calcium_ratio
              the_string << "vitamin_c/#{min_vitamin_c} > calcium/#{max_calcium} AND "
            end
            if vitamin_c_ratio < sodium_ratio
              the_string << "vitamin_c/#{min_vitamin_c} > sodium/#{max_sodium} AND "
            end
            if vitamin_c_ratio < sugar_ratio
              the_string << "vitamin_c/#{min_vitamin_c} > sugar/#{max_sugar} AND "
            end
            if vitamin_c_ratio < price_ratio
              the_string << "vitamin_c/#{min_vitamin_c} > price/#{budget} AND "
            end
            if vitamin_c_ratio < calories_ratio
              the_string << "vitamin_c/#{min_vitamin_c} > calories/#{max_calories} AND "
            end
            if vitamin_c_ratio < carbohydrates_ratio
              the_string << "vitamin_c/#{min_vitamin_c} > carbohydrates/#{max_carbohydrates} AND "
            end
            if vitamin_c_ratio < fat_ratio
              the_string << "vitamin_c/#{min_vitamin_c} > fat/#{max_fat} AND "
            end
            if vitamin_c_ratio < protein_ratio
              the_string << "vitamin_c/#{min_vitamin_c} > protein/#{max_protein} AND "
            end
          end
          
          if calcium_ratio < 1
            if calcium_ratio < sodium_ratio
              the_string << "calcium/#{min_calcium} > sodium/#{max_sodium} AND "
            end
            if calcium_ratio < lower_vitamin_a_ratio
              the_string << "calcium/#{min_calcium} > vitamin_a/#{max_vitamin_a} AND "
            end
            if calcium_ratio < lower_vitamin_c_ratio
              the_string << "calcium/#{min_calcium} > vitamin_c/#{max_vitamin_c} AND "
            end
            if calcium_ratio < lower_iron_ratio
              the_string << "calcium/#{min_calcium} > iron/#{max_iron} AND "
            end
            if calcium_ratio < sugar_ratio
              the_string << "calcium/#{min_calcium} > sugar/#{max_sugar} AND "
            end
            if calcium_ratio < price_ratio
              the_string << "calcium/#{min_calcium} > price/#{budget} AND "
            end
            if calcium_ratio < calories_ratio
              the_string << "calcium/#{min_calcium} > calories/#{max_calories} AND "
            end
            if calcium_ratio < carbohydrates_ratio
              the_string << "calcium/#{min_calcium} > carbohydrates/#{max_carbohydrates} AND "
            end
            if calcium_ratio < fat_ratio
              the_string << "calcium/#{min_calcium} > fat/#{max_fat} AND "
            end
            if calcium_ratio < protein_ratio
              the_string << "calcium/#{min_calcium} > protein/#{max_protein} AND "
            end
          end

          if iron_ratio < 1
            if iron_ratio < lower_vitamin_a_ratio
              the_string << "iron/#{min_iron} > vitamin_a/#{max_vitamin_a} AND "
            end
            if iron_ratio < lower_vitamin_c_ratio
              the_string << "iron/#{min_iron} > vitamin_c/#{max_vitamin_c} AND "
            end
            if iron_ratio < lower_calcium_ratio
              the_string << "iron/#{min_iron} > calcium/#{max_calcium} AND "
            end
            if iron_ratio < sodium_ratio
              the_string << "iron/#{min_iron} > sodium/#{max_sodium} AND "
            end
            if iron_ratio < sugar_ratio
              the_string << "iron/#{min_iron} > sugar/#{max_sugar} AND "
            end
            if iron_ratio < price_ratio
              the_string << "iron/#{min_iron} > price/#{budget} AND "
            end
            if iron_ratio < calories_ratio
              the_string << "iron/#{min_iron} > calories/#{max_calories} AND "
            end
            if iron_ratio < carbohydrates_ratio
              the_string << "iron/#{min_iron} > carbohydrates/#{max_carbohydrates} AND "
            end
            if iron_ratio < fat_ratio
              the_string << "iron/#{min_iron} > fat/#{max_fat} AND "
            end
            if iron_ratio < protein_ratio
              the_string << "iron/#{min_iron} > protein/#{max_protein} AND "
            end
          end

          if raise_calories_ratio < 1
            if raise_calories_ratio < lower_vitamin_a_ratio
              the_string << "calories/#{min_calories} > vitamin_a/#{max_vitamin_a} AND "
            end
            if raise_calories_ratio < lower_vitamin_c_ratio
              the_string << "calories/#{min_calories} > vitamin_c/#{max_vitamin_c} AND "
            end
            if raise_calories_ratio < lower_iron_ratio
              the_string << "calories/#{min_calories} > iron/#{max_iron} AND "
            end
            if raise_calories_ratio < lower_calcium_ratio
              the_string << "calories/#{min_calories} > calcium/#{max_calcium} AND "
            end
            if raise_calories_ratio < sodium_ratio
              the_string << "calories/#{min_calories} > sodium/#{max_sodium} AND "
            end
            if raise_calories_ratio < sugar_ratio
              the_string << "calories/#{min_calories} > sugar/#{max_sugar} AND "
            end
            if raise_calories_ratio < price_ratio
              the_string << "calories/#{min_calories} > price/#{budget} AND "
            end
          end

          if raise_carbohydrates_ratio < 1
            if raise_carbohydrates_ratio < sodium_ratio
              the_string << "carbohydrates/#{min_carbohydrates} > sodium/#{max_sodium} AND "
            end
            if raise_carbohydrates_ratio < lower_vitamin_a_ratio
              the_string << "carbohydrates/#{min_carbohydrates} > vitamin_a/#{max_vitamin_a} AND "
            end
            if raise_carbohydrates_ratio < lower_vitamin_c_ratio
              the_string << "carbohydrates/#{min_carbohydrates} > vitamin_c/#{max_vitamin_c} AND "
            end
            if raise_carbohydrates_ratio < lower_iron_ratio
              the_string << "carbohydrates/#{min_carbohydrates} > iron/#{max_iron} AND "
            end
            if raise_carbohydrates_ratio < lower_calcium_ratio
              the_string << "carbohydrates/#{min_carbohydrates} > calcium/#{max_calcium} AND "
            end
            if raise_carbohydrates_ratio < sugar_ratio
              the_string << "carbohydrates/#{min_carbohydrates} > sugar/#{max_sugar} AND "
            end
            if raise_carbohydrates_ratio < price_ratio
              the_string << "carbohydrates/#{min_carbohydrates} > price/#{budget} AND "
            end
          end

          if raise_fat_ratio < 1
            if raise_fat_ratio < sodium_ratio
              the_string << "fat/#{min_fat} > sodium/#{max_sodium} AND "
            end
            if raise_fat_ratio < lower_vitamin_a_ratio
              the_string << "fat/#{min_fat} > vitamin_a/#{max_vitamin_a} AND "
            end
            if raise_fat_ratio < lower_vitamin_c_ratio
              the_string << "fat/#{min_fat} > vitamin_c/#{max_vitamin_c} AND "
            end
            if raise_fat_ratio < lower_iron_ratio
              the_string << "fat/#{min_fat} > iron/#{max_iron} AND "
            end
            if raise_fat_ratio < lower_calcium_ratio
              the_string << "fat/#{min_fat} > calcium/#{max_calcium} AND "
            end
            if raise_fat_ratio < sugar_ratio
              the_string << "fat/#{min_fat} > sugar/#{max_sugar} AND "
            end
            if raise_fat_ratio < price_ratio
              the_string << "fat/#{min_fat} > price/#{budget} AND "
            end
          end

          if raise_protein_ratio < 1
            if raise_protein_ratio < lower_vitamin_a_ratio
              the_string << "protein/#{min_protein} > vitamin_a/#{max_vitamin_a} AND "
            end
            if raise_protein_ratio < lower_vitamin_c_ratio
              the_string << "protein/#{min_protein} > vitamin_c/#{max_vitamin_c} AND "
            end
            if raise_protein_ratio < lower_iron_ratio
              the_string << "protein/#{min_protein} > iron/#{max_iron} AND "
            end
            if raise_protein_ratio < lower_calcium_ratio
              the_string << "protein/#{min_protein} > calcium/#{max_calcium} AND "
            end
            if raise_protein_ratio < sodium_ratio
              the_string << "protein/#{min_protein} > sodium/#{max_sodium} AND "
            end
            if raise_protein_ratio < sugar_ratio
              the_string << "protein/#{min_protein} > sugar/#{max_sugar} AND "
            end
            if raise_protein_ratio < price_ratio
              the_string << "protein/#{min_protein} > price/#{budget} AND "
            end
          end
          the_string_backup = the_string
          the_string << "(root_cat_name LIKE 'Produce' OR root_cat_name LIKE 'Dairy' OR root_cat_name LIKE 'Grains, Pasta & Beans' OR root_cat_name LIKE 'Meat & Seafood') AND healthy = 2 AND "

        else
          the_string << "root_cat_name LIKE 'Produce' AND healthy = 2 AND "

        end

        can_add_ids = []
        if @last_stepwise_action == "delete"
          hard_delete_foods += [@last_food_id]
        end

        can_add_ids = Food.where(the_string.gsub(/(.*)( AND )(.*)/, '\1\3')).pluck(:id) - hard_delete_foods - list_quantities.pluck(:food_id)
        can_add_length = can_add_ids.length

        if can_add_ids.length == 0
          Rails.logger.info "the string backup"
          can_add_ids = Food.where(the_string_backup.gsub(/(.*)( AND )(.*)/, '\1\3')).pluck(:id) - hard_delete_foods - list_quantities.pluck(:food_id)
          can_add_length = can_add_ids.length
        else
          Rails.logger.info "no backup needed"
        end
        if can_add_ids.length == 0
          Rails.logger.info "the string backup ii"
          can_add_ids = Food.where(empty_list_string.gsub(/(.*)( AND )(.*)/, '\1\3')).pluck(:id) - hard_delete_foods - list_quantities.pluck(:food_id)
          can_add_length = can_add_ids.length
        end

        if can_add_ids.length == 0
          Rails.logger.info "the string backup iii"
          can_add_ids = Food.where(empty_list_string.gsub(/(.*)( AND )(.*)/, '\1\3')).pluck(:id) - hard_delete_foods
          can_add_length = can_add_ids.length
        end
        
        can_add_length = can_add_ids.length
        can_add_that_are_not_favorites = can_add_ids - user_favorites
        can_add_that_are_favorites = can_add_ids - can_add_that_are_not_favorites

        if can_add_length == can_add_that_are_not_favorites.length && can_add_length != 0
          sample_from_these_ids = can_add_ids
        elsif can_add_length != 0
          sample_from_these_ids = can_add_ids + can_add_that_are_favorites * can_add_length
        else
          sample_from_these_ids = nil
        end

        if sample_from_these_ids != nil
          if @mode == "opt"
            minus_list_foods = sample_from_these_ids - list_food_ids
            if minus_list_foods.length != 0
              sample_from_these_ids = minus_list_foods
            end
          end
          if list.total_calories == 0
            new_food = Food.find(sample_from_these_ids.sample)
          else
            min_ratio = r_min.select{|k,v| v == r_min.values.min}.keys.first
            max_ratio = r.select{|k,v| v == r.values.max}.keys.first

            to_choose_from = Food.where("id IN (?)", sample_from_these_ids).order("("+min_ratio+"/("+max_ratio+"+1)) desc")
            to_choose_from_length = to_choose_from.length
            if to_choose_from_length > 0
              sample_amount = to_choose_from_length/3 + 1
              new_food = to_choose_from.first(sample_amount).sample
            end
          end
        else
          Rails.logger.info "else SAMPLED FROM IDS IS NIL, NEW FOOD IS NIL"
        end
        if new_food != nil
          new_food_id = new_food.id
          new_food_amount_guide = 1
          final_message = ["ADD 1",new_food_id]
        else
          Rails.logger.info "new_food is nil because there was nothing that was eligible to add"
        end
      end

      if new_food == nil
        Rails.logger.info "new food is nil"
        safe_to_delete_quantities = list_quantities.pluck(:id) - hard_add_quantities_ids
        if safe_to_delete_quantities.length == 0
          safe_to_delete_quantities = list_quantities.pluck(:id) - [@dont_delete_quantity_id]
        end

        if safe_to_delete_quantities.length != 0
          Rails.logger.info "safe to delete quantities is not zero"
          Rails.logger.info "dont delete q is #{@dont_delete_quantity_id}"
          max_ratio = r.select{|k,v| v == r.values.max}.keys.first
          Rails.logger.info "max ratio is #{max_ratio}"
       #   max_ratio = [lower_vitamin_a_ratio, lower_vitamin_c_ratio, lower_iron_ratio, lower_calcium_ratio, 
       #           sodium_ratio, sugar_ratio, price_ratio, carbohydrates_ratio, 
       #           calories_ratio, fat_ratio, protein_ratio].max

          if "sodium" == max_ratio
            max_ratio_string = "sodium"
            sodium_hash = {}
            safe_to_delete_quantities.each do |f|
              q = Quantity.find(f)
              food = q.food
             # if food.calories != 0
                sodium_hash[f] = food.sodium#*q.amount#/food.calories
             # end   
            end
            max_quantity = sodium_hash.values.max
            if sodium_hash != {}
              delete_quantity_array = sodium_hash.sort_by {|k,v| v}.reverse
              delete_quantity_hash_max = sodium_hash.select { |k, v| v == max_quantity }.keys
              delete_quantity_id = delete_quantity_hash_max.first
            end


          elsif "sugar" == max_ratio
            max_ratio_string = "sugar"
            sugar_hash = {}
            safe_to_delete_quantities.each do |f|
              q = Quantity.find(f)
              food = q.food
              #if food.calories != 0
                sugar_hash[f] = food.sugar#*q.amount#/food.calories
              #end
            end
            max_quantity = sugar_hash.values.max
            if sugar_hash != {}
              delete_quantity_array = sugar_hash.sort_by {|k,v| v}.reverse
              delete_quantity_hash_max = sugar_hash.select { |k, v| v == max_quantity }.keys
              delete_quantity_id = delete_quantity_hash_max.first
            end


          elsif "price" == max_ratio
            max_ratio_string = "price"
            price_hash = {}
            safe_to_delete_quantities.each do |f|
              q = Quantity.find(f)
              food = q.food
              #if food.calories != 0
                price_hash[f] = food.price#*q.amount#/food.calories
              #end
            end
            max_quantity = price_hash.values.max
            if price_hash != {}
              delete_quantity_array = price_hash.sort_by {|k,v| v}.reverse
              delete_quantity_hash_max = price_hash.select { |k, v| v == max_quantity }.keys
              delete_quantity_id = delete_quantity_hash_max.first
            end


          elsif "carbohydrates" == max_ratio
            max_ratio_string = "carbohydrates"
            carbohydrates_hash = {}
            safe_to_delete_quantities.each do |f|
              q = Quantity.find(f)
              food = q.food
              #if food.calories != 0
                carbohydrates_hash[f] = food.carbohydrates#*q.amount##/food.calories
              #end
            end
            max_quantity = carbohydrates_hash.values.max
            if carbohydrates_hash != {}
              delete_quantity_array = carbohydrates_hash.sort_by {|k,v| v}.reverse
              delete_quantity_hash_max = carbohydrates_hash.select { |k, v| v == max_quantity }.keys
              delete_quantity_id = delete_quantity_hash_max.first
            end


          elsif "fat" == max_ratio
            max_ratio_string = "fat"
            fat_hash = {}
            safe_to_delete_quantities.each do |f|
              q = Quantity.find(f)
              food = q.food
              #if food.calories != 0
                fat_hash[f] = food.fat#*q.amount##/food.calories
              #end
            end
            max_quantity = fat_hash.values.max
            if fat_hash != {}
              delete_quantity_array = fat_hash.sort_by {|k,v| v}.reverse
              delete_quantity_hash_max = fat_hash.select { |k, v| v == max_quantity }.keys
              delete_quantity_id = delete_quantity_hash_max.first
            end


          elsif "protein" == max_ratio
            max_ratio_string = "protein"
            protein_hash = {}
            safe_to_delete_quantities.each do |f|
              q = Quantity.find(f)
              food = q.food
              #if food.calories != 0
                protein_hash[f] = food.protein#*q.amount##/food.calories
              #end
            end
            max_quantity = protein_hash.values.max
            if protein_hash != {}
              delete_quantity_array = protein_hash.sort_by {|k,v| v}.reverse.keys
              delete_quantity_hash_max = protein_hash.select { |k, v| v == max_quantity }.keys
              delete_quantity_id = delete_quantity_hash_max.first
            end


          elsif "calories" == max_ratio
            max_ratio_string = "calories"
            calories_hash = {}
            safe_to_delete_quantities.each do |f|
              q = Quantity.find(f)
              food = q.food
              calories_hash[f] = food.calories#*q.amount
            end
            Rails.logger.info calories_hash
            max_quantity = calories_hash.values.max
            if calories_hash != {}
              delete_quantity_array = calories_hash.sort_by {|k,v| v}.reverse
              delete_quantity_hash_max = calories_hash.select { |k, v| v == max_quantity }.keys
              delete_quantity_id = delete_quantity_hash_max.first
            end


          elsif "vitamin_a" == max_ratio
            max_ratio_string = "vitamin_a"
            vitamin_a_hash = {}
            safe_to_delete_quantities.each do |f|
              q = Quantity.find(f)
              food = q.food
              #if food.calories != 0
                vitamin_a_hash[f] = food.vitamin_a#*q.amount##/food.calories
              #end
            end
            max_quantity = vitamin_a_hash.values.max
            if vitamin_a_hash != {}
              delete_quantity_array = vitamin_a_hash.sort_by {|k,v| v}.reverse
              delete_quantity_hash_max = vitamin_a_hash.select { |k, v| v == max_quantity }.keys
              delete_quantity_id = delete_quantity_hash_max.first
            end


          elsif "vitamin_c" == max_ratio
            max_ratio_string = "vitamin_c"
            vitamin_c_hash = {}
            safe_to_delete_quantities.each do |f|
              q = Quantity.find(f)
              food = q.food
              #if food.calories != 0
                vitamin_c_hash[f] = food.vitamin_c#*q.amount##/food.calories
              #end
            end
            max_quantity = vitamin_c_hash.values.max

            if vitamin_c_hash != {}
              delete_quantity_array = vitamin_c_hash.sort_by {|k,v| v}.reverse
              delete_quantity_hash_max = vitamin_c_hash.select { |k, v| v == max_quantity }.keys
              delete_quantity_id = delete_quantity_hash_max.first
            end


          elsif "calcium" == max_ratio
            max_ratio_string = "calcium"
            calcium_hash = {}
            safe_to_delete_quantities.each do |f|
              q = Quantity.find(f)
              food = q.food
              #if food.calories != 0
                calcium_hash[f] = food.calcium#*q.amount##/food.calories
              #end
            end
            max_quantity = calcium_hash.values.max
            if calcium_hash != {}
              delete_quantity_array = calcium_hash.sort_by {|k,v| v}.reverse
              delete_quantity_hash_max = calcium_hash.select { |k, v| v == max_quantity }.keys
              delete_quantity_id = delete_quantity_hash_max.first
            end


          elsif "iron" == max_ratio
            max_ratio_string = "iron"
            iron_hash = {}
            safe_to_delete_quantities.each do |f|
              q = Quantity.find(f)
              food = q.food
              #if food.calories != 0
                iron_hash[f] = food.iron#*q.amount##/food.calories
              #end
            end
            max_quantity = iron_hash.values.max
            if iron_hash != {}
              delete_quantity_array = iron_hash.sort_by {|k,v| v}.reverse
              delete_quantity_hash_max = iron_hash.select { |k, v| v == max_quantity }.keys
              delete_quantity_id = delete_quantity_hash_max.first

            end
          else
            delete_quantity_id = (list_quantities.where.not(food_id: hard_add_foods).pluck(:id) - [@dont_delete_quantity_id]).sample
            max_ratio_string = nil          
          end
          if delete_quantity_id != nil
            if max_ratio_string != nil
              final_message = ["DELETE",delete_quantity_id,max_ratio_string,delete_quantity_array]
            else
              final_message = ["DELETE",delete_quantity_id,nil,delete_quantity_array]
            end
          else
            Rails.logger.info "delete_quantity_id was nil, nothing could be deleted"
          end
        else
          Rails.logger.info "safe_to_delete_quantities == list.quantities, length is zero, list is empty, nothing could be added and nothing could be deleted"
        end
      end


      if new_food == nil && delete_quantity_id == nil
        final_message = ["neither added nor deleted",nil]
        Rails.logger.info "ERROR final_message is neither added nor deleted"
      end 
    else
      final_message = ["this is a healthy list",nil]
    end

    Rails.logger.debug "writelist stepwise final message: #{final_message}"
    final_message
  end
end