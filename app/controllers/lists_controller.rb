class ListsController < QuantitiesController
  
  before_action :logged_in_user, only: [:destroy, :create] #removed :create so that non-logged-in users could try it out
  before_action :authenticate_user!, except: [:create_random_list_name, :index, :show, :list_buy, :build_list, 
    :search, :hard_delete, :instagram_dish, :shuffle_stepwise, :search_and_add, 
    :browse, :update, :start_list_add]
  before_action :correct_user,   only: [:destroy, :edit, :update]
  before_action :set_s3_direct_post, only: [:show, :create, :edit, :update]
  before_action :nutrition_init, :only => [:show]
  respond_to :html, :js
  
  def index
   # @lists = List.order("created_at DESC").reject{|l| l.quantities.count < 4 }.first(21)
   # @posts = Post.order("created_at DESC").first(10)
   # if current_user != nil
   #   @activity = current_user.activities.build(controller:"lists",
   #                                         action:"index",
   #                                         arrived_from: params[:from],
   #                                         ip: request.remote_ip,
   #                                         display: 0)
   # else
   #   @activity = Activity.create(user_id: nil,
   #                                 controller:"lists",
   #                                         action:"index",
   #                                         arrived_from: params[:from],
   #                                         ip: request.remote_ip,
   #                                         display: 0)   
   # end
   # @activity.save!
  end

  def rich_in_nutrient
    @quantity = Quantity.new
    @list_id = params[:list_id]
    @nutrient = params[:nutrient]
    @list = List.find(@list_id)
    @price = params[:price]
    user = @list.user
    user_hard_delete = user.hard_delete.split(",").map(&:to_i)
    
    existing_quantities = Quantity.where(list_id:@list_id).pluck(:food_id)
    if existing_quantities.length == 0
      existing_quantities = [0]
    end
    pref = @list.nutrition_constraints
    the_string = ""
    if pref["dietary_restrictions"] != nil
      the_string = pref["dietary_restrictions"]
    end

    @favorites = user.favorites.split(",").map(&:to_i)

    eligible_foods = ((Food.where(the_string.gsub(/(.*)( AND )(.*)/, '\1\3')).pluck(:id) - user_hard_delete - existing_quantities)+Food.where("user_id = #{user.id}").pluck(:id)).uniq

    @foodsearch = []
    @foodsearch_other = []
    #@foodsearch_already_added = []
    if @nutrient == "sodium" || @nutrient == "sugar"
      ratio = "ratio asc"
      @foodsearch = Food.where("id IN (?)", eligible_foods).where.not(calories:0).where("fiber::float/calories::float>0.05 AND user_id IS null").select("*, ("+@nutrient+"::float / price::float) as ratio").order(ratio).first(20)
    else
      ratio = "ratio desc"
      if @price == 'price'
        @foodsearch = Food.where("id IN (?)", eligible_foods).where.not(calories:0).where("fiber::float/calories::float>0.05 AND user_id IS null").select("*, ("+@nutrient+"::float / price::float) as ratio").order(ratio).first(20)
      else
        @foodsearch = Food.where("id IN (?)", eligible_foods).where.not(calories:0).where("fiber::float/calories::float>0.05 AND user_id IS null").select("*, ("+@nutrient+"::float / calories::float) as ratio").order(ratio).first(20)
      end
    end         

    if @foodsearch.length == 0 && @foodsearch_other.length == 0# && @foodsearch_already_added.length == 0
      @no_results = "No results."
    else
      @no_results = ""
    end


    respond_to do |format|
      format.js {}
      format.html { redirect_to @list }
    end

  end

  def create_list_buy
    user_id = params[:user_id]
    list_id = params[:list_id]
    list_buy_code = params[:list_buy_code]

    if List.exists?(params[:list_id]) && User.exists?(params[:user_id])
      list = List.joins(:quantities).find(params[:list_id])
      @list_buy = User.find(user_id).list_buys.build(
        total_price: list.total_price,
        total_calories: list.total_calories,
        total_carbohydrates: list.total_carbohydrates,
        total_fat: list.total_fat,
        total_protein: list.total_protein,
        total_fiber: list.total_fiber,
        total_vitamin_a: list.total_vitamin_a,
        total_vitamin_c: list.total_vitamin_c,
        total_calcium: list.total_calcium,
        total_iron: list.total_iron,
        total_sodium: list.total_sodium,
        total_sugar: list.total_sugar,
        list_id: params[:list_id]
        )
      @list_buy.save!

      redirect_to @list_buy
    else
      flash[:error] = "Something went wrong."
      redirect_to root_url
      #head 200, content_type: "text/html"
    end
  end

  def find_good_list

    if current_user != nil

      user = current_user
      user_settings = user.settings
      list_days = user_settings["days"].to_i
      max_price = user_settings["budget"].to_i
      budget_per_day = max_price.to_f/list_days.to_f
      percentage = user_settings["percentage"].to_i
      the_name = random_list_name
      age = user_settings["age"].to_i
      gender = user_settings["sex"]
      store = "Peapod"
      user_id = user.id
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
      organic = user_settings["organic"]
      soy_free = user_settings["soy_free"]
      unprocessed = user_settings["unprocessed"]
      custom = user_settings["custom"]
      height = user_settings["height"].to_i
      weight = user_settings["weight"].to_i
      activity_level = user_settings["activity_level"]
      carbohydrates_percentage = user_settings["carbohydrates"].to_i
      fat_percentage = user_settings["fat"].to_i
      protein_percentage = user_settings["protein"].to_i
      min_calories = user_settings["min_calories"].to_i
      max_calories =  user_settings["max_calories"].to_i

      if !(list_days == 0 ||
        max_price == 0 ||
        percentage == 0 ||
        age == 0 ||
        gender == nil || gender == "" ||
        carbohydrates_percentage == 0 ||
        fat_percentage == 0 ||
        protein_percentage == 0 ||
        min_calories == 0 ||
        min_calories == 0 ||
        height == 0 ||
        weight == 0 ||
        activity_level == nil || activity_level == "" ||
        min_fiber == 0 ||
        min_vitamin_a == 0 ||
        min_vitamin_c == 0 ||
        min_iron == 0 ||
        min_calcium == 0 ||
        max_sodium == 0 ||
        user.birthday == nil)

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
        if organic == "1"
          the_string << "organic = 1 AND "
        end
        if soy_free == "1"
          the_string << "soy_free = 1 AND "
        end
      #  if unprocessed == "1"
      #    the_string << "unprocessed = 1 AND "
      #  end
        added_sugar = ["nectar","corn starch","syrup","sugar","sweet","honey","fruit juice","concentrate","dextrose", "fructose", "glucose", "lactose", "maltose", "sucrose"]
        if custom != nil && custom != ""
          custom_array = custom.split(",").map(&:strip) - [""] + added_sugar
        else
          custom_array = added_sugar
        end
        add = custom_array.map {|i| "%"+i+"%"}
        prepare = "#{add}".gsub("\"","\'")
        the_string << "ingredients NOT ILIKE ALL ( array"+prepare+" ) AND "

        @activity = current_user.activities.build(controller:"lists",
                                              action:"find_good_list",
                                              arrived_from: params[:from],
                                            ip: request.remote_ip,
                                            display: 0)
        @activity.save!
        good_lists_string = "user_id != #{current_user.id} AND total_price/days < #{budget_per_day} AND total_calories/days > #{min_calories}*0.9 AND total_calories/days < #{max_calories} AND total_sodium/days < #{max_sodium} AND total_sugar/days < #{max_sugar} AND total_vitamin_a/days < #{max_vitamin_a} AND total_vitamin_a/days > #{min_vitamin_a}*0.9 AND total_vitamin_c/days < #{max_vitamin_c} AND total_vitamin_c/days > #{min_vitamin_c}*0.9 AND total_iron/days < #{max_iron} AND total_iron/days > #{min_iron}*0.9 AND total_calcium/days > #{min_calcium}*0.9 AND total_calcium/days < #{max_calcium} AND total_carbohydrates/days > #{min_carbohydrates}*0.9 AND total_carbohydrates/days < #{max_carbohydrates} AND total_fat/days > #{min_fat}*0.9 AND total_fat/days < #{max_fat} AND total_protein/days > #{min_protein}*0.9 AND total_protein/days < #{max_protein}"
        @good_lists = List.where.not("nutrition_constraints::jsonb ? 'list_users'").where(good_lists_string)

        respond_to do |format|
          format.js {}
          format.html {head 200, content_type: "text/html"}
        end 
      else

        flash[:success] = "Please make sure your profile settings are filled out before building a list."
        redirect_to user_path(user, :user_profile_update_settings => "user_profile_update_settings")

      end

    else
      respond_to do |format|
        format.js {}
        format.html {head 200, content_type: "text/html"}
      end 
    end

  end 

  def send_checklist_mailer
    Rails.logger.info "{ 'controller' => 'lists', 'action' => 'send_checklist_mailer', 'user_id' => #{current_user.id} }"
    @list_id = params[:list_id]
    @user_id = current_user.id
    @user = current_user
    @list = List.find(@list_id)
    ChecklistMailer.checklist_mailer(@list_id, @user_id).deliver_now
    respond_to do |format|
      format.js {}
      format.html {head 200, content_type: "text/html"}
    end 
   # redirect_to add_list_buy_path(:list_id => @list.id, :user_id => @user.id, :list_buy_code => @user.list_buy_code)

  end

  def build_list

    
    user = current_user
    if user == nil
      user = User.find(75)
      Rails.logger.info "{ 'controller' => 'lists', 'action' => 'build_list', 'user_id' => '75' }"
    else
      Rails.logger.info "{ 'controller' => 'lists', 'action' => 'build_list', 'user_id' => #{current_user.id} }"
    end
    user_settings = user.settings
    list_days = user_settings["days"].to_i
    max_price = user_settings["budget"].to_i
    percentage = user_settings["percentage"].to_i
    the_name = user.name+"'s grocery list #"+(user.lists.length+1).to_s
    age = user_settings["age"].to_i
    gender = user_settings["sex"]
    store = "Peapod"
    user_id = user.id
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
    height = user_settings["height"].to_i
    weight = user_settings["weight"].to_i
    activity_level = user_settings["activity_level"]
    carbohydrates_percentage = user_settings["carbohydrates"].to_i
    fat_percentage = user_settings["fat"].to_i
    protein_percentage = user_settings["protein"].to_i
    min_calories = user_settings["min_calories"].to_i
    max_calories =  user_settings["max_calories"].to_i

    if !(list_days == 0 ||
      max_price == 0 ||
      percentage == 0 ||
      age == 0 ||
      gender == nil || gender == "" ||
      carbohydrates_percentage == 0 ||
      fat_percentage == 0 ||
      protein_percentage == 0 ||
      min_calories == 0 ||
      min_calories == 0 ||
      height == 0 ||
      weight == 0 ||
      activity_level == nil || activity_level == "" ||
      min_fiber == 0 ||
      min_vitamin_a == 0 ||
      min_vitamin_c == 0 ||
      min_iron == 0 ||
      min_calcium == 0 ||
      max_sodium == 0 ||
      user.birthday == nil)

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

   #   if store_brand == "1"
   #     the_string << "store_brand = 1 AND "
   #   end
      if organic == "1"
        the_string << "organic = 1 AND "
      end
      if soy_free == "1"
        the_string << "soy_free = 1 AND "
      end
    #  if unprocessed == "1"
     #   the_string << "unprocessed = 1 AND "
      #end
      added_sugar = ["nectar","corn starch","syrup","sugar","sweet","honey","fruit juice","concentrate","dextrose", "fructose", "glucose", "lactose", "maltose", "sucrose"]
      if custom != nil && custom != ""
        custom_array = custom.split(",").map(&:strip) - [""] + added_sugar
      else
        custom_array = added_sugar
      end
      add = custom_array.map {|i| "%"+i+"%"}
      prepare = "#{add}".gsub("\"","\'")
      the_string << "ingredients NOT ILIKE ALL ( array"+prepare+" ) AND "

        
      @list = user.lists.build(days:list_days,
                              name:the_name,
                              age: age,
                              gender: gender,
                              store: store,
                              max_price: max_price,
                              user_id: user_id,
                              percentage: percentage,
                              nutrition_constraints: {
                                min_calories: min_calories,
                                max_calories: max_calories,
                                carbohydrates: carbohydrates_percentage.to_s,
                                fat: fat_percentage.to_s,
                                protein: protein_percentage.to_s,
                                min_carbohydrates: min_carbohydrates,
                                max_carbohydrates: max_carbohydrates,
                                min_fat: min_fat,
                                max_fat: max_fat,
                                min_protein: min_protein,
                                max_protein: max_protein,
                                min_fiber: min_fiber,
                                min_potassium: min_potassium,
                                min_vitamin_a: min_vitamin_a,
                                max_vitamin_a: max_vitamin_a,
                                min_vitamin_c: min_vitamin_c,
                                max_vitamin_c: max_vitamin_c,
                                min_calcium: min_calcium,
                                max_calcium: max_calcium,
                                min_iron: min_iron,
                                max_iron: max_iron,
                                max_sodium: max_sodium,
                                max_sugar: max_sugar,
                                vegetarian: vegetarian,
                                pescatarian: pescatarian,
                                red_meat_free: red_meat_free,
                                dairy_free: dairy_free, 
                                peanut_free: peanut_free,
                                gluten_free: gluten_free,
                               egg_free: egg_free,
                               store_brand: store_brand,
                               organic: organic,
                               soy_free: soy_free,
                               unprocessed: unprocessed,
                               custom: custom,
                               height: height, 
                               weight: weight,
                               activity_level: activity_level,
                               dietary_restrictions: the_string })
      if @list.save!
        if current_user
          @activity = current_user.activities.build(controller:"lists",
                                                action:"build_list",
                                                list_id: @list.id,
                                                arrived_from: params[:from],
                                              ip: request.remote_ip,
                                              display: 1)
          current_user.increment!(:points,5)
        else
          @activity = Activity.create(controller:"lists",
                                                action:"build_list",
                                                list_id: @list.id,
                                                user_id: 75,
                                                arrived_from: params[:from],
                                              ip: request.remote_ip,
                                              display: 1)
        end
        @activity.save!
        redirect_to list_path(@list)
      else
        flash[:success] = "Please make sure your profile settings are filled out before building a list."
        if current_user
          redirect_to user_path(user, :user_profile_update_settings => "user_profile_update_settings")
        else
          redirect_to root_url
        end
      end
    else
      if current_user
        flash[:success] = "Please make sure your profile settings are filled out before building a list."
        redirect_to user_path(user, :user_profile_update_settings => "user_profile_update_settings")
      else
        redirect_to root_url
      end
    end
  end

  def add_person
    Rails.logger.info "{ 'controller' => 'lists', 'action' => 'add_person', 'user_id' => #{current_user.id} }"
    @list = List.find(params[:list_id])
  end
  def edit_person
    @list = List.find(params[:list_id])
    @name = params[:name]
    @person_settings = @list.nutrition_constraints["list_users"][@name]
  end

  def add_person_submit
    Rails.logger.info "{ 'controller' => 'lists', 'action' => 'add_person_submit', 'user_id' => #{current_user.id} }"
    list = List.find(params[:list_id])
    list_days = list.days
    min_calories = params[:min_calories].to_i
    max_calories =  params[:max_calories].to_i
    constraints = list.nutrition_constraints
    min_fiber = params[:min_fiber].to_i
    min_vitamin_a = params[:min_vitamin_a].to_i
    min_vitamin_c = params[:min_vitamin_c].to_i
    min_calcium = params[:min_calcium].to_i
    min_iron = params[:min_iron].to_i
    max_sodium = params[:max_sodium].to_i
    max_sugar = params[:max_sugar].to_i
    new_budget = params[:newbudget]
    add_person_age = params[:age].to_i
    add_person_height = params[:height].to_i
    add_person_weight = params[:weight].to_i
    add_person_sex = params[:sex]
    add_person_activity_level = params[:activity_level]


    if add_person_age < 4
      max_vitamin_a = 75
      max_vitamin_c = 667
      max_calcium = 250
      max_iron = 222
    elsif add_person_age < 9
      max_vitamin_a = 112
      max_vitamin_c = 1080
      max_calcium = 250
      max_iron = 222
    elsif add_person_age < 14
      max_vitamin_a = 212
      max_vitamin_c = 1200
      max_calcium = 300
      max_iron = 222
    elsif add_person_age < 19
      max_vitamin_a = 350
      max_vitamin_c = 2000
      max_calcium = 300
      max_iron = 250
    elsif add_person_age < 51
      max_vitamin_a = 375
      max_vitamin_c = 3333
      max_calcium = 250
      max_iron = 250
    else
      max_vitamin_a = 375
      max_vitamin_c = 3333
      max_calcium = 200
      max_iron = 250
    end
    carbohydrates_percentage = params[:carbohydrates].to_i
    protein_percentage = params[:protein].to_i
    fat_percentage = params[:fat].to_i
    if carbohydrates_percentage == -1
      min_carbohydrates = ((min_calories.to_f/4)*0.1).round
      max_carbohydrates = ((max_calories.to_f/4)*0.9).round
    else
      min_calories_from_carbohydrates = carbohydrates_percentage * 0.01 * min_calories - (100)
      max_calories_from_carbohydrates = carbohydrates_percentage * 0.01 * max_calories + (100)
      min_carbohydrates = (min_calories_from_carbohydrates/4).to_i
      max_carbohydrates = (max_calories_from_carbohydrates/4).to_i
    end
    if fat_percentage == -1
      min_fat = ((min_calories.to_f/9)*0.1).round 
      max_fat = ((max_calories.to_f/9)*0.9).round
    else
      min_calories_from_fat = fat_percentage * 0.01 * min_calories - (100)
      max_calories_from_fat = fat_percentage * 0.01 * max_calories + (100)
      min_fat = (min_calories_from_fat/9).to_i
      max_fat = (max_calories_from_fat/9).to_i
    end
    if protein_percentage == -1
      min_protein = (params[:weight].to_i*0.25).round
      max_protein = (params[:weight].to_i*0.50).round
    else
      min_calories_from_protein = protein_percentage * 0.01 * min_calories - (100)
      max_calories_from_protein = protein_percentage * 0.01 * max_calories + (100)
      min_protein = (min_calories_from_protein/4).to_i
      max_protein = (max_calories_from_protein/4).to_i
    end

    list.update_attribute(:max_price,new_budget)
    new_user_requirements = {"min_calories" => min_calories, 
                             "max_calories" => max_calories,
                             "min_fiber" => min_fiber,
                             "min_vitamin_a" => min_vitamin_a,
                             "min_vitamin_c" => min_vitamin_c,
                             "min_calcium" => min_calcium,
                             "min_iron" => min_iron,
                             "max_vitamin_a" => max_vitamin_a,
                             "max_vitamin_c" => max_vitamin_c,
                             "max_calcium" => max_calcium,
                             "max_iron" => max_iron,
                             "max_sodium" => max_sodium,
                             "max_sugar" => max_sugar,
                             "min_carbohydrates" => min_carbohydrates,
                             "max_carbohydrates" => max_carbohydrates,
                             "min_fat" => min_fat,
                             "max_fat" => max_fat,
                             "min_protein" => min_protein,
                             "max_protein" => max_protein,
                             "carbohydrates" => carbohydrates_percentage,
                             "fat" => fat_percentage,
                             "protein" => protein_percentage,
                             "age" => add_person_age,
                             "height" => add_person_height,
                             "weight" => add_person_weight,
                             "sex" => add_person_sex,
                             "activity_level" => add_person_activity_level
                           }

    if list.nutrition_constraints["list_users"] == nil || list.nutrition_constraints["list_users"] == ""
      new_field = {params[:name] => new_user_requirements}
      list.nutrition_constraints["list_users"] = new_field
      list.save!
      redirect_to list
    else

      old_new_field = list.nutrition_constraints["list_users"]
      if old_new_field[params[:name]] == nil
        old_new_field[params[:name]] = new_user_requirements
        list.save!
        redirect_to list
      else
        redirect_to action: 'add_person', list_id: params[:list_id]
        flash[:error] = "There is already someone with this name on your list. Please select a different name for this new person."
      end
    end

  end


  def edit_person_submit
    Rails.logger.info "{ 'controller' => 'lists', 'action' => 'add_person_submit', 'user_id' => #{current_user.id} }"
    list = List.find(params[:list_id])
    list_days = list.days
    min_calories = params[:min_calories].to_i
    max_calories =  params[:max_calories].to_i
    constraints = list.nutrition_constraints
    min_fiber = params[:min_fiber].to_i
    min_vitamin_a = params[:min_vitamin_a].to_i
    min_vitamin_c = params[:min_vitamin_c].to_i
    min_calcium = params[:min_calcium].to_i
    min_iron = params[:min_iron].to_i
    max_sodium = params[:max_sodium].to_i
    max_sugar = params[:max_sugar].to_i
    new_budget = params[:newbudget]
    add_person_age = params[:age].to_i
    add_person_height = params[:height].to_i
    add_person_weight = params[:weight].to_i
    add_person_sex = params[:sex]
    add_person_activity_level = params[:activity_level]


    if add_person_age < 4
      max_vitamin_a = 75
      max_vitamin_c = 667
      max_calcium = 250
      max_iron = 222
    elsif add_person_age < 9
      max_vitamin_a = 112
      max_vitamin_c = 1080
      max_calcium = 250
      max_iron = 222
    elsif add_person_age < 14
      max_vitamin_a = 212
      max_vitamin_c = 1200
      max_calcium = 300
      max_iron = 222
    elsif add_person_age < 19
      max_vitamin_a = 350
      max_vitamin_c = 2000
      max_calcium = 300
      max_iron = 250
    elsif add_person_age < 51
      max_vitamin_a = 375
      max_vitamin_c = 3333
      max_calcium = 250
      max_iron = 250
    else
      max_vitamin_a = 375
      max_vitamin_c = 3333
      max_calcium = 200
      max_iron = 250
    end
    carbohydrates_percentage = params[:carbohydrates].to_i
    protein_percentage = params[:protein].to_i
    fat_percentage = params[:fat].to_i
    if carbohydrates_percentage == -1
      min_carbohydrates = ((min_calories.to_f/4)*0.1).round
      max_carbohydrates = ((max_calories.to_f/4)*0.9).round
    else
      min_calories_from_carbohydrates = carbohydrates_percentage * 0.01 * min_calories - (100)
      max_calories_from_carbohydrates = carbohydrates_percentage * 0.01 * max_calories + (100)
      min_carbohydrates = (min_calories_from_carbohydrates/4).to_i
      max_carbohydrates = (max_calories_from_carbohydrates/4).to_i
    end
    if fat_percentage == -1
      min_fat = ((min_calories.to_f/9)*0.1).round 
      max_fat = ((max_calories.to_f/9)*0.9).round
    else
      min_calories_from_fat = fat_percentage * 0.01 * min_calories - (100)
      max_calories_from_fat = fat_percentage * 0.01 * max_calories + (100)
      min_fat = (min_calories_from_fat/9).to_i
      max_fat = (max_calories_from_fat/9).to_i
    end
    if protein_percentage == -1
      min_protein = (params[:weight].to_i*0.25).round
      max_protein = (params[:weight].to_i*0.50).round
    else
      min_calories_from_protein = protein_percentage * 0.01 * min_calories - (100)
      max_calories_from_protein = protein_percentage * 0.01 * max_calories + (100)
      min_protein = (min_calories_from_protein/4).to_i
      max_protein = (max_calories_from_protein/4).to_i
    end

    list.update_attribute(:max_price,new_budget)
    new_user_requirements = {"min_calories" => min_calories, 
                             "max_calories" => max_calories,
                             "min_fiber" => min_fiber,
                             "min_vitamin_a" => min_vitamin_a,
                             "min_vitamin_c" => min_vitamin_c,
                             "min_calcium" => min_calcium,
                             "min_iron" => min_iron,
                             "max_vitamin_a" => max_vitamin_a,
                             "max_vitamin_c" => max_vitamin_c,
                             "max_calcium" => max_calcium,
                             "max_iron" => max_iron,
                             "max_sodium" => max_sodium,
                             "max_sugar" => max_sugar,
                             "min_carbohydrates" => min_carbohydrates,
                             "max_carbohydrates" => max_carbohydrates,
                             "min_fat" => min_fat,
                             "max_fat" => max_fat,
                             "min_protein" => min_protein,
                             "max_protein" => max_protein,
                             "carbohydrates" => carbohydrates_percentage,
                             "fat" => fat_percentage,
                             "protein" => protein_percentage,
                             "age" => add_person_age,
                             "height" => add_person_height,
                             "weight" => add_person_weight,
                             "sex" => add_person_sex,
                             "activity_level" => add_person_activity_level
                           }

    if params[:orig_name] == params[:name]
      update_field = new_user_requirements
      list.nutrition_constraints["list_users"][params[:name]] = update_field
      list.save!
      redirect_to list
    else

      if list.nutrition_constraints["list_users"][params[:name]] == nil
    #    list.nutrition_constraints["list_users"][params[:name]] = list.nutrition_constraints["list_users"][params[:orig_name]]
        list.nutrition_constraints["list_users"].delete(params[:orig_name])
        list.nutrition_constraints["list_users"][params[:name]] = new_user_requirements
        list.save!
        redirect_to list
      else
        redirect_to action: 'add_person', list_id: params[:list_id]
        flash[:error] = "There is already someone with this name on your list. Please select a different name for this new person."
      end
    end
  end


  def show
    if List.exists?(params[:id].to_i)
      #if !browser.device.mobile? || params[:show_full]
        @list_id = params[:id]
        if Quantity.where(list_id:@list_id).length != 0
          @list = List.joins(:quantities).find(@list_id)
          if current_user != nil
            @activity = current_user.activities.build(controller:"lists",
                                          action:"show",
                                          arrived_from: params[:from],
                                          list_id: params[:id],
                                              ip: request.remote_ip,
                                              display: 0)

          else
            @activity = Activity.create(controller:"lists",
                                          action:"show",
                                          arrived_from: params[:from],
                                          list_id: params[:id],
                                          user_id:nil,
                                              ip: request.remote_ip,
                                              display: 0)
          end
          @activity.save!
        else
          @list = List.find(@list_id)
        end
        if current_user != nil
          if @list.user == current_user
            user_lists = current_user.lists.pluck(:id)
            @frequent_foods = ( Quantity.where(list_id:user_lists).pluck(:food_id).group_by {|i| i}.sort_by {|_, a| -a.count}.map &:first ) - @list.quantities.pluck(:id)
          end
          Rails.logger.info "{ 'controller' => 'lists', 'action' => 'show', 'list_id' => #{@list_id}, 'user_id' => #{current_user.id} }"
        elsif @list.user_id == 75
          @frequent_foods = ( Quantity.all.pluck(:food_id).group_by {|i| i}.sort_by {|_, a| -a.count}.map &:first ) - @list.quantities.pluck(:id)
        else
          #@frequent_foods = []
          Rails.logger.info "{ 'controller' => 'lists', 'action' => 'show', 'list_id' => #{@list_id}, 'user_id' => 'nil' }"
        end
        @root_cat_names = ["Produce", "Grains, Pasta & Beans", "Dairy", "Meat & Seafood", "Frozen", "Deli", "Soups & Canned Goods", 
          "Snacks", "Condiments & Sauces", "Bakery", "Baking & Cooking Needs", "Beverages", "Breakfast & Cereal", "Health & Beauty" ]
        @root_cat_names_browse = ["Produce", "Grains, Pasta & Beans", "Dairy", "Meat & Seafood", "Frozen", "Deli", "Soups & Canned Goods", 
          "Snacks", "Condiments & Sauces", "Bakery", "Baking & Cooking Needs", "Beverages", "Breakfast & Cereal"]#, "Health & Beauty" ]
        @did_not_add = params[:did_not_add]
        @successfully_added = params[:successfully_added]
        
        

        list = @list
        list_user = @list.user

        @quantity = Quantity.new
        @post = Post.new
        @quantities = Quantity.where(list: @list).order("created_at desc")
        @posts = Post.where(list: @list).order("created_at asc")
        
        favorites = list_user.favorites.split(",").map(&:to_i)

        list_foods = list.foods.pluck(:id)
        if current_user == @list.user
          @eligible_favorites = favorites
        elsif current_user == nil && @list.user.id == 75
          @eligible_favorites = Food.where.not(id:list_foods).order("number_of_favorites DESC").pluck(:id).first(30)
        end
  #     @eligible_favorites = Food.where(id:eligible_favorites)
        is_forked = Activity.where.not(forked_list_id:nil).where(list_id:@list_id)
        if is_forked.length > 0
          if List.exists?(is_forked.first.forked_list_id)
            @parent_list = List.find(is_forked.first.forked_list_id)
          end
        end
      #else
      #  redirect_to add_list_buy_path(:list_id => @list_id, :user_id => current_user.id, :list_buy_code => current_user.list_buy_code)
      #end
    else
      head 200, content_type: "text/html"
      Rails.logger.info "{ 'controller' => 'lists', 'action' => 'show', 'error' => 'list_id.to_i == 0' }"
    end
  end


  def favorite_to_list
    @favorite = Food.find(params[:favoriter][:id])
    @list = List.find(params[:list_id])
    Rails.logger.info "{ 'controller' => 'lists', 'action' => 'favorite_to_list', 'food_id' => #{params[:favoriter][:id]}, 'list_id' => #{params[:list_id]}, 'user_id' => #{current_user.id} }"
    if @list.user == current_user || current_user.admin?
      @quantity = Quantity.create(food_id:@favorite.id,list_id:params[:list_id],amount:1)
      if @quantity.save
        quantity_id = @quantity.id
        food_id = @quantity.food_id
        list_hard_add = @list.hard_add.split(",").map(&:to_i)
        if @list.quantities.where(food_id:food_id).length > 1
          new_amount = @list.quantities.where(food_id:food_id).pluck(:amount).sum
          list_hard_add_new = list_hard_add + [quantity_id]
          list_hard_add_new = list_hard_add_new - @list.quantities.where.not(id:quantity_id).where(food_id:food_id).pluck(:id)
          list_hard_add_new = list_hard_add_new.uniq.join(",")<<","
          @list.quantities.where.not(id:quantity_id).where(food_id:food_id).destroy_all
          @list.update_attribute(:hard_add,list_hard_add_new)
          @quantity.update_attribute(:amount, new_amount)
        else
          HardAdd.new(quantity_id).hard_add
        end  
        UpdateListAttributes.new(params[:list_id]).update_list_attributes          
      end
      head 200, content_type: "text/html"
    end
  end

  def fork
    user_id = current_user.id
    list_id = params[:list_id]
    list = List.find(list_id)
    Rails.logger.info "{ 'controller' => 'lists', 'action' => 'copy', 'list_id' => #{list_id}, 'user_id' => #{current_user.id} }"
    new_list_id = Copy.new(list, user_id).copy
    @activity = current_user.activities.build(controller:"lists",
                                            action:"fork",
                                            list_id: new_list_id,
                                            forked_list_id: params[:list_id],
                                            arrived_from: params[:from],
                                            ip: request.remote_ip,
                                            display: 1)
    @activity.save!
    current_user.increment!(:points,3)
    if list.user != current_user
      list.user.increment!(:points,7)
    end
    new_list = List.find(new_list_id)
    if list.user != current_user
      new_list.nutrition_constraints["list_users"] = nil
      new_list.private_note = ""
    end
    new_list.save!
    if list.user != current_user
      ForkMailer.fork_mailer(params[:list_id], List.find(params[:list_id]).user_id,current_user.id, new_list_id).deliver_now
    end
    redirect_to List.find(new_list_id)
  end  


  def new
    Rails.logger.info "{ 'controller' => 'lists', 'action' => 'new', 'user_id' => #{current_user.id} }"
    @list = List.new
    @user = current_user
  end
  
  def edit
    @list = List.find(params[:id])
    Rails.logger.info "{ 'controller' => 'lists', 'action' => 'edit', 'list_id' => #{@list.id}, 'user_id' => #{current_user.id} }"
  end

  def create
    @user = current_user
    @list = @user.lists.build(list_params)

    if @list.save
      head 200, content_type: "text/html"
      if current_user
        Rails.logger.info "{ 'controller' => 'lists', 'action' => 'create', 'user_id' => #{current_user.id} }"
      else
        Rails.logger.info "{ 'controller' => 'lists', 'action' => 'create', 'user_id' => 75 }"
      end
    else
      render 'new'
      if current_user
        Rails.logger.info "{ 'controller' => 'lists', 'action' => 'create', 'user_id' => #{current_user.id}, 'error' => 'resource_not_saved' }"
      else
        Rails.logger.info "{ 'controller' => 'lists', 'action' => 'create', 'user_id' => 75, 'error' => 'resource_not_saved' }"
      end
    end
  end

  def start_list_add
    @quantity = Quantity.new
    food_id = params[:food_id].to_i
    list_id = params[:list_id].to_i
    if current_user
      Rails.logger.info "{ 'controller' => 'lists', 'action' => 'start_list_add', 'food_id' => #{food_id}, 'list_id' => #{list_id}, 'user_id' => #{current_user.id} }"
    else
      Rails.logger.info "{ 'controller' => 'lists', 'action' => 'start_list_add', 'food_id' => #{food_id}, 'list_id' => #{list_id}, 'user_id' => 75 }"
    end
    @list = List.find(list_id)
    list = @list
    @quantity = @list.quantities.build(food_id:food_id,amount:1)
    @quantity.save
    quantity_id = @quantity.id
    list_hard_add = @list.hard_add.split(",").map(&:to_i)
    if !list_hard_add.include?(quantity_id)
      HardAdd.new(quantity_id).hard_add
    end
    UpdateListAttributes.new(list_id).update_list_attributes

    respond_to do |format|
      format.js {}
      format.html { redirect_to @list }
    end
  end

  def start_list_add_undo
    food_id = params[:food_id].to_i
    list_id = params[:list_id].to_i
    @list = List.find(list_id)
    Rails.logger.info "{ 'controller' => 'lists', 'action' => 'start_list_add_undo', 'food_id' => #{food_id}, 'list_id' => #{list_id}, 'user_id' => #{current_user.id} }"
    if Quantity.where(list_id:list_id).where(food_id:food_id).length != 0
      quantity_to_destroy = Quantity.where(list_id:list_id).where(food_id:food_id).first 
      quantity_id = quantity_to_destroy.id
      quantity_to_destroy.destroy
      hard_add = @list.hard_add.split(",").map(&:to_i)
      if hard_add.include?(quantity_id.to_i)
        new_hard_add = hard_add - [quantity_id.to_i]
        new_hard_add = new_hard_add.uniq.join(",")<<","
        if new_hard_add == ","
          new_hard_add = ""
        end
        @list.update_attribute(:hard_add, new_hard_add)
      end
    end
    UpdateListAttributes.new(list_id).update_list_attributes
    head 200, content_type: "text/html"
  end




  def instagram_dish
    url = params[:url]
    list_id = params[:list_id]
    response = `curl "https://api.instagram.com/oembed/?url=#{url}"`
    json_url = JSON.parse(response)
    if json_url["title"]
      if current_user
        insta_user_id = current_user.id
      else
        insta_user_id = 75
      end
      @new_dish = List.find(list_id).posts.build(user_id:insta_user_id,
                                      body: json_url["title"],
                                      title: json_url["title"][0,40],
                                      instagram_user: json_url["author_name"],
                                      instagram_user_url: json_url["author_url"],
                                      instagram_url: url)
      if @new_dish.save
        if current_user
          @activity = current_user.activities.build(controller:"lists",
                                            action:"instagram_dish",
                                            arrived_from: params[:from],
                                            ip: request.remote_ip,
                                            display: 1,
                                            post_id: @new_dish.id,
                                            list_id: list_id,
                                            user_id: current_user.id)
        else
          @activity = Activity.create(controller:"lists",
                                                action:"instagram_dish",
                                                list_id: list_id,
                                                user_id: 75,
                                                arrived_from: params[:from],
                                              ip: request.remote_ip,
                                              post_id: @new_dish.id,
                                              display: 1)
        end
        @activity.save!
        
      end
      image = @new_dish.images.build(caption:"",image_url:json_url["thumbnail_url"])
      image.save!
    else
      @something_went_wrong = true
    end
    respond_to do |format|
      format.js {}
      format.html {head 200, content_type: "text/html"}
    end
  end

  def search
    @quantity = Quantity.new
    @list_id = params[:list_id]
    @list = List.find(@list_id)
    user = @list.user
    user_hard_delete = user.hard_delete.split(",").map(&:to_i) #+ Food.where.not(user_id:nil)
    
    existing_quantities = Quantity.where(list_id:@list_id).pluck(:food_id)
    if existing_quantities.length == 0
      existing_quantities = [0]
    end
   
    if params[:search]
      if params[:search].length > 2
        params_search = params[:search].downcase

        if current_user
          Rails.logger.info "{ 'controller' => 'lists', 'action' => 'search', 'list_id' => #{@list.id}, 'user_id' => #{current_user.id}, 'search_term' => '#{params[:search]}' }"
        else
          Rails.logger.info "{ 'controller' => 'lists', 'action' => 'search', 'list_id' => #{@list.id}, 'user_id' => 75, 'search_term' => '#{params[:search]}' }"
        end
        exclude_queries = {
          "butter" => ["peanut butter"],
          "cream" => ["ice cream", "whipped cream"]
        }
        foodsearch_base = Food.search(params_search, fields: ["name^10","ingredients"], where: {healthy: 2}, misspellings: {edit_distance: 2}).pluck(:id)

        @foodsearch = foodsearch_base - existing_quantities - user_hard_delete
        if @foodsearch.length == 0 
          @no_results = "No results. Please try a different search term."
          @activity = Activity.create(user_id: user.id,
                                        controller:"lists",
                                        action:"search(failed)",
                                        arrived_from: params[:search],
                                        list_id: @list_id,
                                        ip: request.remote_ip,
                                        display: 0)
          @activity.save!
        else
          @no_results = ""
          @activity = Activity.create(user_id: user.id,
                                        controller:"lists",
                                        action:"search",
                                        arrived_from: params[:search],
                                        list_id: @list_id,
                                        ip: request.remote_ip,
                                        display: 0)
          @activity.save!
        end
      else
        @no_results = "No results. Please try a different search term."
        @foodsearch = []
        @foodsearch_other = []
       # @foodsearch_already_added = []
      end
    else
      @foodsearch = []
    end
    respond_to do |format|
      format.js {}
      format.html { redirect_to @list }
    end
  end



  def search_and_add
    @root_cat_names_init = ["Produce", "Grains, Pasta & Beans", "Dairy", "Meat & Seafood", "Frozen", "Deli", "Soups & Canned Goods", "Snacks", "Condiments & Sauces", "Bakery", "Baking & Cooking Needs", "Beverages", "Breakfast & Cereal", "Health & Beauty" ]
    @quantity = Quantity.new
    @list_id = params[:list_id]
    @list = List.find(@list_id)
    if current_user
      Rails.logger.info "{ 'controller' => 'lists', 'action' => 'search_and_add', 'list_id' => #{@list_id}, 'user_id' => #{current_user.id} }"
    else
      Rails.logger.info "{ 'controller' => 'lists', 'action' => 'search_and_add', 'list_id' => #{@list_id}, 'user_id' => 75 }"
    end
    user = @list.user
    user_hard_delete = user.hard_delete.split(",").map(&:to_i)
    @favorites = user.favorites.split(",").map(&:to_i)
    pref = @list.nutrition_constraints
    
    the_string = ""
    if pref["dietary_restrictions"] != nil
      the_string = pref["dietary_restrictions"]
    end
    list_foods = @list.foods.pluck(:id)
    list_hard_delete = @list.hard_delete.split(",").map(&:to_i)
    user_hard_delete = @list.user.hard_delete.split(",").map(&:to_i)
    ineligible_array = (list_hard_delete + user_hard_delete + list_foods).uniq
    @search_and_add_eligible_foods = ((Food.where(the_string.gsub(/(.*)( AND )(.*)/, '\1\3')).pluck(:id) - ineligible_array)).uniq
    @root_cat_names = @root_cat_names_init - (@root_cat_names_init - Food.where(id:@search_and_add_eligible_foods).where.not(sub_cat_name:nil).pluck(:root_cat_name).uniq)
    respond_to do |format|
      format.js {}
      format.html { redirect_to @list }
    end
  end



  def browse
    @quantity = Quantity.new
    @list_id = params[:list_id]
    @list = List.find(@list_id)
    if current_user 
      Rails.logger.info "{ 'controller' => 'lists', 'action' => 'browse', 'list_id' => #{@list_id}, 'user_id' => #{current_user.id} }"
    else
      Rails.logger.info "{ 'controller' => 'lists', 'action' => 'browse', 'list_id' => #{@list_id}, 'user_id' => 75 }"
    end
    user = @list.user
    user_hard_delete = user.hard_delete.split(",").map(&:to_i)
    @favorites = user.favorites.split(",").map(&:to_i)

    list_foods = @list.foods.pluck(:id)
    list_hard_delete = @list.hard_delete.split(",").map(&:to_i)
    user_hard_delete = user.hard_delete.split(",").map(&:to_i)
    ineligible_array = (list_hard_delete + user_hard_delete + list_foods).uniq
    pref = @list.nutrition_constraints
    the_string = ""
    if pref["dietary_restrictions"] != nil
      the_string = pref["dietary_restrictions"]
    end


    if params[:root_cat]
      the_string << "root_cat_name ILIKE '#{params[:root_cat]}' AND healthy = 2 AND "
    end

    @eligible_foods = ((Food.where(the_string.gsub(/(.*)( AND )(.*)/, '\1\3')).order("(fiber::float/(sugar::float+1)) DESC").pluck(:id) - ineligible_array)).uniq

    respond_to do |format|
      format.js {}
      format.html { head 200, content_type: "text/html" }
    end

  end



  def shuffle_stepwise
    if current_user
      shuffle_user_id = current_user.id
    else
      shuffle_user_id = 75
    end

    @list_id = params[:list_id]
    if Quantity.where(list_id:@list_id).length != 0
      list = List.joins(:quantities).find(@list_id)
    else
      list = List.find(@list_id)
    end
    user = list.user
    @list = list
    
    if params[:mode] == "opt"
      @mode = "opt"
    elsif params[:mode] == "auto"
      @mode = "auto"
    end

    if params[:stepwise_action] != nil
      @stepwise_action = params[:stepwise_action]
      if params[:stepwise_quantity_id] != nil
        @stepwise_quantity_id = params[:stepwise_quantity_id].to_i
        @destroy_entirely = params[:destroy_entirely]
        if @destroy_entirely != "true"
          @stepwise_quantity = Quantity.find(@stepwise_quantity_id)
        end
      end
    end

    last_food_id = params[:food_id]
    dont_delete_quantity_id = params[:dont_delete_quantity_id]
    food_step = WriteListStepwise.new(list,last_food_id,dont_delete_quantity_id,params[:stepwise_action]).write

    @food_action = food_step[0]
    @target_id = food_step[1]
    if food_step[2] != nil
      @max_ratio_string = food_step[2].gsub('_',' ')
    else
      @max_ratio_string = nil
    end
    Rails.logger.info "{ 'controller' => 'lists', 'action' => 'shuffle_stepwise', 'list_id' => #{@list_id}, 'user_id' => #{shuffle_user_id}, 'mode' => #{params[:mode]}, 'food_action' => #{@food_action}, 'target_id' => #{@target_id} }"

    if @food_action == "ADD 1"
      food_id = food_step[1].to_i
      @js_message = "#{Food.find(food_id).name.split.map(&:capitalize).join(' ')}"
      if @list.quantities.pluck(:food_id).include? food_id
        existing_quantity = @list.quantities.where(food_id:food_id).first
        @existing_quantity_amount = existing_quantity.amount
      end
    elsif @food_action == "DELETE"
      @array_to_delete = food_step[3]
      @js_message = "#{Quantity.find(food_step[1]).food.name.split.map(&:capitalize).join(' ')}"
    end

    @user = user

    if params[:array_of_quantities_to_destroy] != nil
      @array_of_quantities_to_destroy = params[:array_of_quantities_to_destroy].gsub("[","").gsub("]","").split(",").map(&:to_i)
    end
    UpdateListAttributes.new(@list_id).update_list_attributes
    respond_to do |format|
        format.js {}
        format.html {redirect_to list, notice: "Signal to add or delete a food (JS must be enabled)."}
    end

  end

  def update

    @list = List.find(params[:id])
    original_list_name = @list.name
    original_list_note = @list.note
    original_list_private_note = @list.private_note
    original_list_image = @list.image
    original_list_users = @list.nutrition_constraints["list_users"]
    if current_user
      Rails.logger.info "{ 'controller' => 'lists', 'action' => 'update', 'list_id' => #{@list.id}, 'user_id' => #{current_user.id} }"
    else
      Rails.logger.info "{ 'controller' => 'lists', 'action' => 'update', 'list_id' => #{@list.id}, 'user_id' => 75 }"
    end
    if @list.update_attributes(list_params)
      nutrition_constraints = @list.nutrition_constraints
      #original_list_users = nutrition_constraints["list_users"]
      user = @list.user

      min_calories = nutrition_constraints["min_calories"].to_i
      max_calories =  nutrition_constraints["max_calories"].to_i
      if nutrition_constraints["carbohydrates"] == nil || nutrition_constraints["carbohydrates"] == ""
        carbohydrates_percentage = -1
      else
        carbohydrates_percentage = nutrition_constraints["carbohydrates"].to_i
      end
      if nutrition_constraints["fat"] == nil || nutrition_constraints["fat"] == "" 
        fat_percentage = -1
      else
        fat_percentage = nutrition_constraints["fat"].to_i
      end
      if nutrition_constraints["protein"] == nil || nutrition_constraints["protein"] == "" 
        protein_percentage = -1
      else
        protein_percentage = nutrition_constraints["protein"].to_i
      end
      list_age = @list.age.to_i
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
        min_protein = (user.settings["weight"].to_i*0.25).round
        max_protein = (user.settings["weight"].to_i*0.50).round
      else
        min_calories_from_protein = protein_percentage * 0.01 * min_calories - 100
        max_calories_from_protein = protein_percentage * 0.01 * max_calories + 100
        min_protein = (min_calories_from_protein/4).to_i
        max_protein = (max_calories_from_protein/4).to_i
      end
      if list_age < 4
        max_vitamin_a = 75
        max_vitamin_c = 667 
        max_calcium = 250 
        max_iron = 222 
      elsif list_age < 9
        max_vitamin_a = 112 
        max_vitamin_c = 1080 
        max_calcium = 250 
        max_iron = 222 
      elsif list_age < 14
        max_vitamin_a = 212 
        max_vitamin_c = 1200 
        max_calcium = 300 
        max_iron = 222 
      elsif list_age < 19
        max_vitamin_a = 350 
        max_vitamin_c = 2000 
        max_calcium = 300 
        max_iron = 250 
      elsif list_age < 51
        max_vitamin_a = 375 
        max_vitamin_c = 3333 
        max_calcium = 250 
        max_iron = 250 
      else
        max_vitamin_a = 375 
        max_vitamin_c = 3333 
        max_calcium = 200 
        max_iron = 250 
      end
      @list.nutrition_constraints["max_vitamin_a"] = max_vitamin_a
      @list.nutrition_constraints["max_vitamin_c"] = max_vitamin_c
      @list.nutrition_constraints["max_calcium"] = max_calcium
      @list.nutrition_constraints["max_iron"] = max_iron
      @list.nutrition_constraints["min_carbohydrates"] = min_carbohydrates
      @list.nutrition_constraints["max_carbohydrates"] = max_carbohydrates      
      @list.nutrition_constraints["min_fat"] = min_fat
      @list.nutrition_constraints["max_fat"] = max_fat
      @list.nutrition_constraints["min_protein"] = min_protein
      @list.nutrition_constraints["max_protein"] = max_protein
      @list.nutrition_constraints["list_users"] = original_list_users

      
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

      if nutrition_constraints["organic"] == "1"
        the_string << "organic = 1 AND "
      end
      if nutrition_constraints["soy_free"] == "1"
        the_string << "soy_free = 1 AND "
      end

      if nutrition_constraints["custom"] != nil && nutrition_constraints["custom"] != ""
        custom = nutrition_constraints["custom"].split(",").map(&:strip) - [""]
        add = custom.map {|i| "%"+i+"%"}
        prepare = "#{add}".gsub("\"","\'")
        the_string << "ingredients NOT ILIKE ALL ( array"+prepare+" ) AND "
      end

      @list.nutrition_constraints["dietary_restrictions"] = the_string
      @list.save!  
      if current_user
        if @list.name != original_list_name
          activity = current_user.activities.build(controller:"lists",
                                        action:"update",
                                        list_id: params[:id],
                                        attribute_updated: "name",
                                              ip: request.remote_ip,
                                              display: 0)
          activity.save!
        elsif @list.note != original_list_note
          Activity.where(list_id:params[:id],attribute_updated:"note").update_all(:display=>0)
          activity = current_user.activities.build(controller:"lists",
                                        action:"update",
                                        list_id: params[:id],
                                        attribute_updated: "note",
                                              ip: request.remote_ip,
                                              display: 1)
          activity.save!
        elsif @list.private_note != original_list_private_note
          #Activity.where(list_id:params[:id],attribute_updated:"private_note").update_all(:display=>0)
          activity = current_user.activities.build(controller:"lists",
                                        action:"update",
                                        list_id: params[:id],
                                        attribute_updated: "private_note",
                                              ip: request.remote_ip,
                                              display: 0)
          activity.save!
        elsif @list.image != original_list_image
          old_url = @list.image; 
          new_url = old_url.gsub("tna-main.s3.amazonaws.com","d1esj6dpdcntt5.cloudfront.net")
          @list.update_attribute(:image,new_url)

          Activity.where(list_id:params[:id],attribute_updated:"image").update_all(:display=>0)
          activity = current_user.activities.build(controller:"lists",
                                        action:"update",
                                        list_id: params[:id],
                                        attribute_updated: "image",
                                              ip: request.remote_ip,
                                              display: 1)
          activity.save!
          current_user.increment!(:points,7)
        end
      end
      respond_to do |format|
          format.js {}
          format.html {redirect_to @list}
      end
    else
      render 'edit'
    end
  end
    
  def hard_delete
    quantity_id = params[:param].to_i
    quantity = Quantity.find(quantity_id)
    delete_food_id = quantity.food_id
    delete_food = Food.find(delete_food_id)
    list = quantity.list
    @list = list
    if current_user
      Rails.logger.info "{ 'controller' => 'lists', 'action' => 'hard_delete', 'list_id' => #{@list.id}, 'user_id' => #{current_user.id}, 'food_id' => #{delete_food_id} }"
    else
      Rails.logger.info "{ 'controller' => 'lists', 'action' => 'hard_delete', 'list_id' => #{@list.id}, 'user_id' => 75, 'food_id' => #{delete_food_id} }"
    end
    user = list.user
    user_id = user.id
    list_id = list.id
    list_hard_delete = list.hard_delete.split(",").map(&:to_i)
    if !list_hard_delete.include?(delete_food_id)
      HardDelete.new(quantity_id, list_id, user_id, delete_food_id, true).hard_delete
    end
    @quantity_id = quantity_id

    UpdateListAttributes.new(list_id).update_list_attributes

    respond_to do |format|
      format.js {}
      format.html {redirect_to list, notice: "Destroy a quantity (JS must be enabled)."}
    end
  end
  
  def create_random_list_name
    @random_list_name = random_list_name
    if current_user != nil
      Rails.logger.info "{ 'controller' => 'lists', 'action' => 'create_random_list_name', 'user_id' => #{current_user.id}, 'name' => #{@random_list_name} }"
      @activity = current_user.activities.build(controller:"lists",
                                  action:"create_random_list_name",
                                  arrived_from: params[:from],
                                            ip: request.remote_ip,
                                            display: 0)    
    else
      @activity = Activity.create(user_id:75,
                                  controller:"lists",
                                  action:"create_random_list_name",
                                  arrived_from: params[:from],
                                            ip: request.remote_ip,
                                            display: 0)

      Rails.logger.info "{ 'controller' => 'lists', 'action' => 'create_random_list_name', 'user_id' => 'nil', 'name' => #{@random_list_name} }"
    end
    @activity.save!


    
    respond_to do |format|
      format.js {}
      format.html { head 200, content_type: "text/html" }
    end
  end

  def destroy
    @list = List.find(params[:id])
    Rails.logger.info "{ 'controller' => 'lists', 'action' => 'destroy', 'list_id' => #{params[:id]}, 'user_id' => #{current_user.id} }"
    @list.destroy
    Activity.where(list_id:params[:id]).destroy_all
    head 200, content_type: "text/html"
  end
  
  private

      def list_params
        params.require(:list).permit(:days,
                                       :name,
                                       :total_calories, 
                                       :total_carbohydrates,
                                       :total_fat,
                                       :total_protein,
                                       :total_sugar,
                                       :total_potassium,
                                       :total_fiber,
                                       :age,
                                       :total_vitamin_a,
                                       :total_vitamin_c,
                                       :total_calcium,
                                       :total_iron,
                                       :total_sodium,
                                       :total_price,
                                       :gender,
                                       :store,
                                       :max_price,
                                       :hard_delete,
                                       :hard_add,
                                       :user_id,
                                       :note,
                                       :private_note,
                                       :featured,
                                       :job_id,
                                       :job_finished_at,
                                       :percentage,
                                       :image,
                                       nutrition_constraints:[
                                       :min_calories, 
                                       :max_calories, 
                                       :carbohydrates, 
                                       :fat, 
                                       :protein,
                                       :min_carbohydrates,
                                       :max_carbohydrates,
                                       :min_fat,
                                       :max_fat,
                                       :min_protein,
                                       :max_protein,
                                       :min_fiber, 
                                       :min_potassium, 
                                       :min_vitamin_a, 
                                       :max_vitamin_a,
                                       :min_vitamin_c,
                                       :max_vitamin_c,
                                       :min_calcium, 
                                       :max_calcium,
                                       :min_iron, 
                                       :max_iron,
                                       :max_sodium, 
                                       :max_sugar, 
                                       :vegetarian, 
                                       :pescatarian, 
                                       :red_meat_free,
                                       :dairy_free, 
                                       :peanut_free,
                                       :gluten_free,
                                       :egg_free,
                                       :kosher,
                                       :store_brand,
                                       :organic,
                                       :soy_free,
                                       :unprocessed,
                                       :custom,
                                       :height, 
                                       :weight,
                                       :activity_level,
                                       :list_users,
                                       :dietary_restrictions]
                                       )

      end
      
      def correct_user
        if current_user
          @list = current_user.lists.find_by(id: params[:id])
          redirect_to root_url if @list.nil?
        else
          if params[:id] == 75
            redirect_to root_url
          end
        end
      end



      def set_s3_direct_post

        if current_user
          if current_user.lists.find_by(id: params[:id])
            @s3_direct_post = S3_BUCKET.presigned_post(key: "uploads/#{current_user.id}/list_photos/#{params[:id]}/#{SecureRandom.uuid}/${filename}", success_action_status: '201', acl: 'public-read', content_type: "")
          end
        else
          if User.find(75).lists.find_by(id: params[:id])
            @s3_direct_post = S3_BUCKET.presigned_post(key: "uploads/75/list_photos/#{params[:id]}/#{SecureRandom.uuid}/${filename}", success_action_status: '201', acl: 'public-read', content_type: "")
          end
        end

      end

      
end