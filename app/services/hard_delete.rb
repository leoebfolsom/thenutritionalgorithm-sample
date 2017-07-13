class HardDelete

  def initialize(quantity_id, list_id, user_id, delete_food_id, hard)
    @delete_quantity_id = quantity_id
    if list_id != nil
      @list = List.find(list_id)
    end
    @user = User.find(user_id)
    @delete_food_id = delete_food_id
    @hard = hard
  end

  def hard_delete
    @delete_quantity = Quantity.find(@delete_quantity_id) 
    list_hard_add = @list.hard_add.split(",").map(&:to_i)
    if @delete_quantity.amount > 1 && @hard == false
      new_delete_quantity_amount = @delete_quantity.amount - 1.0
      @delete_quantity.update_attribute(:amount,new_delete_quantity_amount)
    else
      if list_hard_add.include?(@delete_quantity_id.to_i)
        list_hard_add_new = list_hard_add - [@delete_quantity_id.to_i]
        list_hard_add_new = list_hard_add_new.uniq.join(",")<<","
        if list_hard_add_new == ","
          list_hard_add_new = ""
        end
        @list.update_attribute(:hard_add, list_hard_add_new)
      end
      if @hard == true
        list_hard_delete = @list.hard_delete.split(",").map(&:to_i)
        list_hard_delete += [@delete_food_id]
        list_hard_delete_new = list_hard_delete.uniq.join(",")<<","
        @list.update_attribute(:hard_delete, list_hard_delete_new)
      end
      @delete_quantity.destroy
    end

  end

  def hard_delete_user

    food_id = @delete_food_id
    food = Food.find(food_id)
    user = @user
    if user.id != 75
      user_hard_delete = user.hard_delete.split(",").map(&:to_i)
      user_favorites = user.favorites.split(",").map(&:to_i)

      if user_favorites.include?(food_id)
        new_favorites = user_favorites
        new_favorites = new_favorites -= [food_id]
        new_favorites = new_favorites.uniq.join(",")<<","
        if new_favorites == ","
          new_favorites = ""
        end
        user.update_attribute(:favorites,new_favorites)
        current_favorite_count = food.number_of_favorites
        if current_favorite_count > 0
          current_favorite_count -= 1
          food.update_attribute(:number_of_favorites, current_favorite_count)
        end
      end
      if !user_hard_delete.include?(food_id)
        new_hard_delete = user_hard_delete
        new_hard_delete += [food_id]
        new_hard_delete = new_hard_delete.uniq.join(",")<<","
        if new_hard_delete == ","
          new_hard_delete = ""
        end
        user.update_attribute(:hard_delete,new_hard_delete)
      end
    end
  end

  def undo_hard_delete_user

    food_id = @delete_food_id
    food = Food.find(food_id)
    user = @user
    user_hard_delete = user.hard_delete.split(",").map(&:to_i)
    if user_hard_delete.include?(food_id)
      new_hard_delete = user_hard_delete
      new_hard_delete -= [food_id]
      new_hard_delete = new_hard_delete.uniq.join(",")<<","
      if new_hard_delete == ","
        new_hard_delete = ""
      end
      user.update_attribute(:hard_delete,new_hard_delete)
    end

  end

end