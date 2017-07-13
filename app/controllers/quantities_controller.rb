class QuantitiesController < ApplicationController
  respond_to :html, :js

  def index
    @quantities = Quantity.paginate(page: params[:page])
    Rails.logger.info "{ 'controller' => 'quantities', 'action' => 'user_favorite', 'user_id' => #{current_user.id}, 'context' => 'add_and_like' }"

  end  
  
  def show
    @quantity = Quantity.find(params[:id])
  end
  
  def new
    @quantity = Quantity.new
  end

  def create
    @quantity = Quantity.new(quantity_params)
    Rails.logger.info("start def create quantity")
    if @quantity.save
      Rails.logger.info("quantity is saved")
      quantity_id = @quantity.id
      food_id = @quantity.food_id
      if @quantity.list_id != nil
        @list_id = @quantity.list_id
        UpdateListAttributes.new(@list_id).update_list_attributes
        if Quantity.where(list_id:@list_id).length != 0
          @list = List.joins(:quantities).find(@list_id)
        else
          @list = List.find(@list_id)
        end
        if @list.user == current_user || (@list.user.id == 75 && current_user == nil)
          list_hard_add = @list.hard_add.split(",").map(&:to_i)
          if @list.quantities.where(id:food_id).length > 1    
            new_amount = @list.quantities.where(food_id:food_id).pluck(:amount).sum
            list_hard_add_new = list_hard_add - @list.quantities.where.not(id:quantity_id).where(food_id:food_id).pluck(:id)
            list_hard_add_new = list_hard_add_new.uniq.join(",")<<","
            @list.quantities.where.not(id:@quantity.id).where(food_id:food_id).destroy_all
            @list.update_attribute(:hard_add,list_hard_add_new)
            @quantity.update_attribute(:amount, new_amount)
          else
            HardAdd.new(quantity_id).hard_add
          end
        end
      end


      
      list = @list
      @list_days = list.days
      @min_protein = list.nutrition_constraints["min_protein"].to_i
      @max_protein = list.nutrition_constraints["max_protein"].to_i
      @min_fat = list.nutrition_constraints["min_fat"].to_i
      @max_fat = list.nutrition_constraints["max_fat"].to_i
      @min_carbohydrates = list.nutrition_constraints["min_carbohydrates"].to_i
      @max_carbohydrates = list.nutrition_constraints["max_carbohydrates"].to_i

      @min_protein_day = (@min_protein/@list_days).round
      @max_protein_day = (@max_protein/@list_days).round
      @min_fat_day = (@min_fat/@list_days).round
      @max_fat_day = (@max_fat/@list_days).round
      @min_carbohydrates_day = (@min_carbohydrates/@list_days).round
      @max_carbohydrates_day = (@max_carbohydrates/@list_days).round
      if @min_protein_day == 0
        @min_protein_day = 1
      end
      if @min_carbohydrates_day == 0
        @min_carbohydrates_day = 1
      end
      if @min_fat_day == 0
        @min_fat_day = 1
      end
      @list_total_carbohydrates = @list.total_carbohydrates.to_f
      @carbohydrates_success = (@list_total_carbohydrates/@list_days).round
      @progress_min_carbohydrates = (@carbohydrates_success.to_f/@min_carbohydrates_day)*100
      @progress_max_carbohydrates = (@carbohydrates_success.to_f/@max_carbohydrates_day)*100
      if @progress_min_carbohydrates < 100
        @progress_carbohydrates = @progress_min_carbohydrates.round
      elsif @progress_max_carbohydrates > 100
        @progress_carbohydrates = @progress_max_carbohydrates.round
      else
        @progress_carbohydrates = 100
      end

      @list_total_fat = @list.total_fat.to_f
      @fat_success = (@list_total_fat/@list_days).round
      @progress_min_fat = (@fat_success.to_f/@min_fat_day)*100
      @progress_max_fat = (@fat_success.to_f/@max_fat_day)*100
      if @progress_min_fat < 100
        @progress_fat = @progress_min_fat.round
      elsif @progress_max_fat > 100
        @progress_fat = @progress_max_fat.round
      else
        @progress_fat = 100
      end

      @list_total_protein = @list.total_protein.to_f
      @protein_success = (@list_total_protein/@list_days).round
      @progress_min_protein = (@protein_success.to_f/@min_protein_day)*100
      @progress_max_protein = (@protein_success.to_f/@max_protein_day)*100
      if @progress_min_protein < 100
        @progress_protein = @progress_min_protein.round
      elsif @progress_max_protein > 100
        @progress_protein = @progress_max_protein.round
      else
        @progress_protein = 100
      end

      respond_to do |format|
        format.js {}
        format.html {redirect_to @list, notice: "Signal to add or delete a food (JS must be enabled)."}
      end
    else
      Rails.logger.info("quantity is not saved")
      redirect_to root_url
    end

  end

  def add_food_stepwise
    was_hard_add = false
    @array_of_quantities_to_destroy = []
    list_id = params[:list_id]

    if Quantity.where(list_id:list_id).length != 0
      @list = List.joins(:quantities).find(list_id)
    else
      @list = List.find(list_id)
    end
    if params[:mode] == "opt"
      combined_amount = params[:amount].to_i
      percentage = params[:percentage].to_i
    else
      combined_amount = 1
      percentage = 100
    end
    if @list.quantities.pluck(:food_id).include? params[:food_id].to_i
      @list.quantities.where(food_id:params[:food_id]).each do |q|
      # combined_amount += q.amount
        @array_of_quantities_to_destroy.push(q.id)
        list_hard_add = @list.hard_add.split(",").map(&:to_i)
        if list_hard_add.include?(q.id.to_i)
          UndoHardAdd.new(q).undo_hard_add
          was_hard_add = true
        end
        q.destroy
      end
    end
    @quantity = Quantity.create(food_id:params[:food_id],list_id:list_id,amount:combined_amount,percentage:percentage)
    quantity_id = @quantity.id
    

    #Repeat because the list has been altered.
    if Quantity.where(list_id:list_id).length != 0
      @list = List.joins(:quantities).find(list_id)
    else
      @list = List.find(list_id)
    end

    if !@list.hard_add.split(",").map(&:to_i).include? quantity_id
      if params[:mode] == "opt" || was_hard_add == true
        HardAdd.new(quantity_id).hard_add
      end
    end

    if params[:add_and_like] != nil
      food_id = params[:food_id].to_i
      if current_user
        Rails.logger.info "{ 'controller' => 'users', 'action' => 'user_favorite', 'user_id' => #{current_user.id}, 'context' => 'add_and_like' }"
      else
        Rails.logger.info "{ 'controller' => 'users', 'action' => 'user_favorite', 'user_id' => 75, 'context' => 'add_and_like' }"
      end
      user = @list.user
      user_id = user.id



      user_favorites = user.favorites.split(",").map(&:to_i)
      user_hard_delete = user.hard_delete.split(",").map(&:to_i)

      if user_hard_delete.include?(food_id)
        delete_food_id = food_id
        quantity_id = nil; destroy_entirely = nil
        HardDelete.new(quantity_id, list_id, user_id, delete_food_id, destroy_entirely).undo_hard_delete_user
      end


      if !user_favorites.include?(food_id)

        Favorite.new(food_id, user_id).favorite

      end
      food = Food.find(food_id)
      current_favorite_count = food.number_of_favorites
      current_favorite_count += 1
      food.update_attribute(:number_of_favorites, current_favorite_count)
    end
    UpdateListAttributes.new(list_id).update_list_attributes
    if params[:mode] == "opt"
      mode = "opt"
    else
      mode = "auto"
    end
    redirect_to "/shuffle_stepwise?list_id=#{params[:list_id]}&stepwise_action=add&stepwise_quantity_id=#{quantity_id}&array_of_quantities_to_destroy=#{@array_of_quantities_to_destroy}&mode=#{mode}"
  end

  
  def delete_food_stepwise
    quantity_id = params[:quantity_id]
    list_id = params[:list_id]
    user = current_user
    if current_user
      user_id = user.id
    else
      user_id = 75

    end
    @delete_quantity = Quantity.find(quantity_id)
    @list = List.find(list_id)
    delete_food_id = @delete_quantity.food_id
    #user_favorites = user.favorites.split(",").map(&:to_i)
    if current_user
      user_hard_delete = user.hard_delete.split(",").map(&:to_i)
    else
      user_hard_delete = []
    end
    if params[:delete_and_dislike] != nil
      destroy_entirely = true
      if !user_hard_delete.include?(delete_food_id)
        HardDelete.new(quantity_id, list_id, user_id, delete_food_id, destroy_entirely).hard_delete_user
      end
    else
      if @delete_quantity.amount > 1
        destroy_entirely = false
      else
        destroy_entirely = true
      end
    end
    HardDelete.new(quantity_id, list_id, user_id, delete_food_id, destroy_entirely).hard_delete

    if params[:mode] == "opt"
      mode = "opt"
    else
      mode = "auto"
    end
    UpdateListAttributes.new(list_id).update_list_attributes
    redirect_to "/shuffle_stepwise?list_id=#{params[:list_id]}&stepwise_action=delete&stepwise_quantity_id=#{@delete_quantity.id}&mode=#{mode}&destroy_entirely=#{destroy_entirely}&food_id=#{delete_food_id}"
  end



  def add_food_stepwise_skip
    delete_food_id = params[:food_id]
    list_id = params[:list_id]
    @list = List.find(list_id)

    if !(@list.hard_delete.split(",").map(&:to_i).include? delete_food_id)
      new_hard_delete = @list.hard_delete << "#{delete_food_id},"
      @list.update_attribute(:hard_delete, new_hard_delete)
    end

    if params[:skip_and_dislike] != nil
      if current_user
        Rails.logger.info "{ 'controller' => 'users', 'action' => 'hard_delete_user_from_profile', 'user_id' => #{current_user.id}, 'context' => 'skip_and_dislike' }"
      else
        Rails.logger.info "{ 'controller' => 'users', 'action' => 'hard_delete_user_from_profile', 'user_id' => 75, 'context' => 'skip_and_dislike' }"
      end
      user_id = @list.user.id; quantity_id = nil; destroy_entirely = nil
      HardDelete.new(quantity_id, list_id, user_id, delete_food_id, destroy_entirely).hard_delete_user
    end
    redirect_to "/shuffle_stepwise?list_id=#{params[:list_id]}&mode=opt"
  end

  def delete_food_stepwise_skip
    @quantity_id = params[:quantity_id]
    @list = List.find(params[:list_id])
    if !(@list.hard_add.split(",").map(&:to_i).include? @quantity_id)
      HardAdd.new(@quantity_id).hard_add
    end

    redirect_to "/shuffle_stepwise?list_id=#{params[:list_id]}&mode=opt&dont_delete_quantity_id=#{@quantity_id}"
  end

  def edit
    @quantity = Quantity.find(params[:id])
  end

  def pantry

    quantity_id = params[:quantity_id]
    quantity = Quantity.find(quantity_id)


    food_id = quantity.food_id
    list_id = quantity.list_id
    @list = quantity.list
    list_hard_add = @list.hard_add.split(",").map(&:to_i)
    if !(list_hard_add.include? quantity_id)
      HardAdd.new(quantity_id).hard_add
    end
    quantity.update_attribute(:pantry, 1)
    respond_to do |format|
      format.js {}
      format.html {head 200, content_type: "text/html"}
    end
  end

  def pantry_remove

    quantity_id = params[:quantity_id]
    quantity = Quantity.find(quantity_id)
    list_id = quantity.list_id
    quantity.update_attribute(:pantry,0)
    #redirect_to List.find(list_id)
    @list = quantity.list
    respond_to do |format|
      format.js {}
      format.html {head 200, content_type: "text/html"}
    end
  end
  
  def update
    @quantity_id = params[:id]
    @quantity = Quantity.find(@quantity_id)
    list_id = @quantity.list_id
    @list_id = list_id
    if Quantity.where(list_id:@list_id).length != 0
      @list = List.joins(:quantities).find(@list_id)
    else
      @list = List.find(@list_id)
    end



    if @list.user == current_user || (@list.user.id == 75 && current_user == nil)
      amount = @quantity.amount
      @strikethrough_init = @quantity.strikethrough
      @ate_init = @quantity.ate
      if @quantity.update_attributes(quantity_params)
        if amount != @quantity.amount
          HardAdd.new(@quantity.id).hard_add
        end
      end
    end



    @strikethrough_now = @quantity.strikethrough
    @ate_now = @quantity.ate
    if @strikethrough_now != @strikethrough_init
      if @strikethrough_now == 1
        @quantity.update_attribute(:bought_at,DateTime.now)
      else
        @quantity.update_attribute(:bought_at,nil)
      end
    end
    if @ate_now != @ate_init
      if @ate_now == 1
        @quantity.update_attribute(:ate_at,DateTime.now)
      else
        @quantity.update_attribute(:ate_at,nil)
      end
    end



    list = @list
    UpdateListAttributes.new(list_id).update_list_attributes

    @list_days = list.days
    list_nutrition_constraints = list.nutrition_constraints
    @min_protein = list_nutrition_constraints["min_protein"].to_i
    @max_protein = list_nutrition_constraints["max_protein"].to_i
    @min_fat = list_nutrition_constraints["min_fat"].to_i
    @max_fat = list_nutrition_constraints["max_fat"].to_i
    @min_carbohydrates = list_nutrition_constraints["min_carbohydrates"].to_i
    @max_carbohydrates = list_nutrition_constraints["max_carbohydrates"].to_i

    @min_protein_day = (@min_protein/@list_days).round
    @max_protein_day = (@max_protein/@list_days).round
    @min_fat_day = (@min_fat/@list_days).round
    @max_fat_day = (@max_fat/@list_days).round
    @min_carbohydrates_day = (@min_carbohydrates/@list_days).round
    @max_carbohydrates_day = (@max_carbohydrates/@list_days).round
    if @min_protein_day == 0
      @min_protein_day = 1
    end
    if @min_carbohydrates_day == 0
      @min_carbohydrates_day = 1
    end
    if @min_fat_day == 0
      @min_fat_day = 1
    end
    @list_total_carbohydrates = @list.total_carbohydrates.to_f
    @carbohydrates_success = (@list_total_carbohydrates/@list_days).round
    @progress_min_carbohydrates = (@carbohydrates_success.to_f/@min_carbohydrates_day)*100
    @progress_max_carbohydrates = (@carbohydrates_success.to_f/@max_carbohydrates_day)*100
    if @progress_min_carbohydrates < 100
      @progress_carbohydrates = @progress_min_carbohydrates.round
    elsif @progress_max_carbohydrates > 100
      @progress_carbohydrates = @progress_max_carbohydrates.round
    else
      @progress_carbohydrates = 100
    end

    @list_total_fat = @list.total_fat.to_f
    @fat_success = (@list_total_fat/@list_days).round
    @progress_min_fat = (@fat_success.to_f/@min_fat_day)*100
    @progress_max_fat = (@fat_success.to_f/@max_fat_day)*100
    if @progress_min_fat < 100
      @progress_fat = @progress_min_fat.round
    elsif @progress_max_fat > 100
      @progress_fat = @progress_max_fat.round
    else
      @progress_fat = 100
    end

    @list_total_protein = @list.total_protein.to_f
    @protein_success = (@list_total_protein/@list_days).round
    @progress_min_protein = (@protein_success.to_f/@min_protein_day)*100
    @progress_max_protein = (@protein_success.to_f/@max_protein_day)*100
    if @progress_min_protein < 100
      @progress_protein = @progress_min_protein.round
    elsif @progress_max_protein > 100
      @progress_protein = @progress_max_protein.round
    else
      @progress_protein = 100
    end

    respond_to do |format|
      format.js {}
      format.html {redirect_to @list, notice: "Signal to add or delete a food (JS must be enabled)."}
    end

  end
  
  def destroy
    @quantity = Quantity.find(params[:id])
    @list = @quantity.list
    list_hard_add = @list.hard_add.split(",").map(&:to_i)
    if list_hard_add.include?(@quantity.id)
      UndoHardAdd.new(@quantity).undo_hard_add
    end
    @quantity.destroy
    UpdateListAttributes.new(@list.id).update_list_attributes
    redirect_to @list

  end
  
  private
    def quantity_params
      params.require(:quantity).permit(:food_id, 
                                       :list_id,
                                       :amount, 
                                       :note,
                                       :strikethrough,
                                       :ate,
                                       :ate_at,
                                       :bought_at,
                                       :pantry,
                                       :percentage)
    end
end