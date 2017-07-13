class UndoFavorite
  
  def initialize(food_id, user)
    @food_id = food_id.to_i
    @user = user
  end
  
  def undo_favorite
    
    favorites = @user.favorites.split(",").map(&:to_i)
    favorites = favorites - [@food_id]
    favorites = favorites.uniq.join(",")<<","
    food = Food.find(@food_id)
    current_favorite_count = food.number_of_favorites
    if current_favorite_count > 0
      current_favorite_count -= 1
      food.update_attribute(:number_of_favorites, current_favorite_count)
    end
    if favorites == ","
      favorites = ""
    end
    @user.update_attribute(:favorites, favorites)
  end
  
end