class FoodsController < ApplicationController
 # before_action :admin_user,     only: :destroy
  before_action :correct_user,   only: [:destroy, :edit, :update]
  
  
  def index
    #@foods = Food.paginate(page: params[:page])

    @foods = Food.where(user_id:current_user.id).order("name ASC").paginate(page: params[:page])
    #@available = Food.all.where(food_store: @list.store) - Food.all.where(id: Quantity.all.where(list: @list).pluck(:food_id)) - Food.all.where(id: @list.hard_delete.split(",").map(&:to_i))
    #if params[:search]
     # @foodsearch = Food.search(params[:search]).order("name ASC")
    #  redirect_to @list
    #else
    #  @foodsearch = ""
    #end
  end

  def show
    @food = Food.find(params[:id])
  end
  
  def new
    @food = Food.new
  end
  
  def create
    @food = Food.new(food_params)

    if @food.save
      Rails.logger.info "{ 'controller' => 'foods', 'action' => 'create', 'user_id' => #{current_user.id}, 'food_id' => #{@food.id} }"
      flash[:success] = "A food has been created!"
      redirect_to '/foods'
      @activity = current_user.activities.build(controller:"foods",
                                            action:"create",
                                            arrived_from: params[:from],
                                            ip: request.remote_ip,
                                            display: 0)
      @activity.save!
    else
      Rails.logger.info "{ 'controller' => 'foods', 'action' => 'create', 'user_id' => #{current_user.id}, 'error' => 'did not save }"
      render 'new'
    end
  end
  
  def edit
    @food = Food.find(params[:id])
  end
  
  def update
    @food = Food.find(params[:id])
    if @food.update_attributes(food_params)
      Rails.logger.info "{ 'controller' => 'foods', 'action' => 'create', 'user_id' => #{current_user.id}, 'food_id' => #{@food.id} }"
      flash[:success] = "food attributes updated"
      redirect_to @food
    else
      Rails.logger.info "{ 'controller' => 'foods', 'action' => 'create', 'user_id' => #{current_user.id}, 'error' => 'did not save' }"
      render 'edit'
    end
  end
  
  def destroy
    Food.find(params[:id]).destroy
    Rails.logger.info "{ 'controller' => 'foods', 'action' => 'create', 'user_id' => #{current_user.id}, 'food_id' => #{params[:id]} }"
    flash[:success] = "Food deleted"
    redirect_to foods_url
  end
  
  private

    def food_params
      params.require(:food).permit(:name, 
                                  :calories, 
                                  :carbohydrates,
                                  :fat,
                                  :protein,
                                  :sugar,
                                  :potassium, 
                                  :fiber, 
                                  :vitamin_a,
                                  :vitamin_c,
                                  :calcium, 
                                  :iron,
                                  :sodium,
                                  :price,
                                  :food_store,
                                  :food_store_id,
                                  :aisle,
                                  :meat,
                                  :image,
                                  :number_of_favorites,
                                  :nutri,
                                 :dairy_free, 
                                 :peanut_free,
                                 :gluten_free,
                                 :egg_free,
                                 :kosher,
                                 :store_brand,
                                 :organic,
                                 :soy_free,
                                 :unprocessed,
                                 :ingredients,
                                 :user_id,
                                 :root_cat_name,
                                 :sub_cat_name
                                  )
    end

      def correct_user
        @food = current_user.foods.find_by(id: params[:id])
        redirect_to root_url if @food.nil?
      end


end