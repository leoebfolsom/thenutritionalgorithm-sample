class Favorite

  def initialize(food_id, user_id)
    @food_id = food_id
    @user = User.find(user_id)
  end

  def favorite
    food_id = @food_id
    if @user.id != 75
      user_favorites = @user.favorites.split(",").map(&:to_i)
      user_hard_delete = @user.hard_delete.split(",").map(&:to_i)
      if user_hard_delete.include?(food_id)
        new_user_hard_delete = user_hard_delete
        new_user_hard_delete -= [food_id]
        new_user_hard_delete = new_user_hard_delete.uniq.join(",")<<","
        if new_user_hard_delete == ","
          new_user_hard_delete = ""
        end
        user.update_attribute(:hard_delete,new_user_hard_delete)
      end

      if !user_favorites.include?(food_id)
        new_favorites = user_favorites + [food_id]
        new_favorites = new_favorites.uniq.join(",")<<","
        if new_favorites == ","
          new_favorites = ""
        end
        @user.update_attribute(:favorites, new_favorites)

      end

    end
  end

  def undo_favorite
    user_favorites = @user.favorites.split(",").map(&:to_i)
    user_hard_delete = @user.hard_delete.split(",").map(&:to_i)
    food_id = @food_id.to_i
    food = Food.find(food_id)
    if user_favorites.include?(food_id)
      new_favorites = user_favorites - [food_id]
      new_favorites = new_favorites.uniq.join(",")<<","
      if new_favorites == ","
        new_favorites = ""
      end
      @user.update_attribute(:favorites, new_favorites)
      current_favorite_count = food.number_of_favorites
      if current_favorite_count > 0
        current_favorite_count -= 1
        food.update_attribute(:number_of_favorites, current_favorite_count)
      end
    end
  end

end