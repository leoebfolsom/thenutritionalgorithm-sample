class UsersController < ApplicationController
 # before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!#, except: :create_from_guest
  before_action :authenticate_user!, except: [:user_dishes, :skip_liker, :user_favorite, :hard_delete_user_from_profile, :index, :show]
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy,
                                          :following, :followers]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy
  before_action :set_s3_direct_post, only: [:show, :new, :edit, :create, :update]
  respond_to :html, :js
  
  def index
    @users = User.paginate(page: params[:page])
    respond_to do |format|

      format.html # show.html.erb
      format.json { render json: @users }

    end
  end

  def logged_in_reset
    @user = current_user
    sign_out(@user)
    redirect_to new_user_password_url
  end

  def show
    if params[:id] == "75"
      redirect_to new_user_registration_url
    else
      @user = User.find(params[:id])
      if current_user != nil
        @activity = current_user.activities.build(controller:"users",
                                              action:"show",
                                              arrived_from: params[:from],
                                              ip: request.remote_ip,
                                              viewed_user_id: params[:id],
                                              display: 0)
      else
        @activity = Activity.create(user_id: nil,
                                    controller:"users",
                                              action:"show",
                                              arrived_from: params[:from],
                                              ip: request.remote_ip,
                                              viewed_user_id: params[:id],
                                              display: 0)
      end
      @activity.save!
    #@user_lists = @user.lists.joins(:quantities)
    # @spoons = Activity.where(action:"spoon",user_id:params[:id]).pluck(:list_id)
      if params[:change_settings] != nil
        @change_settings = "change"
      else
        @change_settings = nil
      end
      if params[:user_profile_favorites] != nil
        @user_profile_favorites = "user_profile_favorites"
      else
        @user_profile_favorites = nil
      end
      if params[:user_profile_update_settings] != nil
        @user_profile_update_settings = "user_profile_update_settings"
      else
        @user_profile_update_settings = nil
      end    

    end
  end

  def chart_generate


    respond_to do |format|
      format.js {}
      format.html { redirect_to head 200, content_type: "text/html" }
    end
  end

  def user_likes
    @user = User.find(params[:user_id])
    @favorites = Food.where(id:@user.favorites.split(",").map(&:to_i))
    respond_to do |format|
      format.js {}
      format.html { redirect_to @user }
    end
  end

  def user_dislikes
    @user = User.find(params[:user_id])
    @dislikes = Food.where(id:@user.hard_delete.split(",").map(&:to_i))
    respond_to do |format|
      format.js {}
      format.html { redirect_to @user }
    end
  end
  def user_dishes
    @user = User.find(params[:user_id])
    @dishes = Post.where(user_id:params[:user_id]).order("created_at desc")
    respond_to do |format|
      format.js {}
      format.html { redirect_to @user }
    end
  end

  def search_favorite
    user = current_user
    user_favorites = user.favorites.split(",").map(&:to_i)
    user_hard_delete = user.hard_delete.split(",").map(&:to_i)

    @foodsearch = ""

    pref = user.settings
    the_string = ""
    if pref["vegetarian"] == "1"
      the_string << "meat = 0 AND "
    elsif pref["pescatarian"] == "1"
      the_string << "(meat = 0 OR meat = 2) AND "
    elsif pref["red_meat_free"] == "1"
      the_string << "(meat = 0 OR meat = 1 OR meat = 2) AND "
    end
    if pref["dairy_free"] == "1"
      the_string << "dairy_free = 1 AND "
    end
    if pref["peanut_free"] == "1"
      the_string << "peanut_free = 1 AND "
    end
    if pref["gluten_free"] == "1"
      the_string << "gluten_free = 1 AND "
    end
    if pref["egg_free"] == "1"
      the_string << "egg_free = 1 AND "
    end

    if pref["organic"] == "1"
      the_string << "organic = 1 AND "
    end
    if pref["soy_free"] == "1"
      the_string << "soy_free = 1 AND "
    end

    if pref["custom"] != nil && pref["custom"] != ""
      custom = pref["custom"].split(",").map(&:strip) - [""]
      add = custom.map {|i| "%"+i+"%"}
      prepare = "#{add}".gsub("\"","\'")
      the_string << "ingredients NOT ILIKE ALL ( array"+prepare+" ) AND "
    end
    ineligible_array = user_favorites + user_hard_delete
    eligible_foods = Food.where(the_string.gsub(/(.*)( AND )(.*)/, '\1\3')).pluck(:id) - ineligible_array

    if params[:search_favorite]
      @foodsearch = Food.where("id IN (?)", eligible_foods).search(params[:search_favorite].downcase).order("healthy desc")
      if @foodsearch.length == 0
        @no_results = "No results. Please try a different search term."
      else
        @no_results = ""
      end
    end
    respond_to do |format|
      format.js {}
      format.html { redirect_to @user }
    end
  end

  def search_dislike
    user = current_user
    user_favorites = user.favorites.split(",").map(&:to_i)
    user_hard_delete = user.hard_delete.split(",").map(&:to_i)
    @foodsearch = ""
    pref = user.settings
    the_string = ""
    if pref["vegetarian"] == "1"
      the_string << "meat = 0 AND "
    elsif pref["pescatarian"] == "1"
      the_string << "(meat = 0 OR meat = 2) AND "
    elsif pref["red_meat_free"] == "1"
      the_string << "(meat = 0 OR meat = 1 OR meat = 2) AND "
    end
    if pref["dairy_free"] == "1"
      the_string << "dairy_free = 1 AND "
    end
    if pref["peanut_free"] == "1"
      the_string << "peanut_free = 1 AND "
    end
    if pref["gluten_free"] == "1"
      the_string << "gluten_free = 1 AND "
    end
    if pref["egg_free"] == "1"
      the_string << "egg_free = 1 AND "
    end

    if pref["organic"] == "1"
      the_string << "organic = 1 AND "
    end
    if pref["soy_free"] == "1"
      the_string << "soy_free = 1 AND "
    end

    if pref["custom"] != nil && pref["custom"] != ""
      custom = pref["custom"].split(",").map(&:strip) - [""]
      add = custom.map {|i| "%"+i+"%"}
      prepare = "#{add}".gsub("\"","\'")
      the_string << "ingredients NOT ILIKE ALL ( array"+prepare+" ) AND "
    end
    ineligible_array = user_favorites + user_hard_delete
    eligible_foods = Food.where(the_string.gsub(/(.*)( AND )(.*)/, '\1\3')).pluck(:id) - ineligible_array
    @dislikesearch = ""
    if params[:search_dislike]
      @dislikesearch = Food.where("id IN (?)", eligible_foods).search(params[:search_dislike].downcase).order("healthy desc")
      if @dislikesearch.length == 0
        @no_results = "No results. Please try a different search term."
      else
        @no_results = ""
      end
    end
    respond_to do |format|
      format.js {}
      format.html { redirect_to @user }
    end
  end

  def new
    @user = User.new

  end
  
  def create
    
    if @user.save
      Rails.logger.info "{ 'controller' => 'users', 'action' => 'create', 'user_id' => #{@user.id} }"
      @guest_list_id = params[:extraparam].to_i
      List.find(@guest_list_id).update_attribute(:user_id, @user.id)
      flash[:info] = "Welcome! Please check your email to activate your account."
      
      redirect_to root_url


   else
      render 'new'
      Rails.logger.info "{ 'controller' => 'users', 'action' => 'create', 'error' => 'user not created' }"
    end
  end

  def user_favorite
    food_id = params[:param].to_i
    @quantity_id = params[:quantity_id]
    if params[:from_list] != nil
      @from_list = true
    else
      @from_list = false
    end
   
    if current_user != nil
      Rails.logger.info "{ 'controller' => 'users', 'action' => 'user_favorite', 'user_id' => #{current_user.id}, 'food_id' => #{food_id} }"
      user = current_user
      user_id = user.id
      user_favorites = user.favorites.split(",").map(&:to_i)
      user_hard_delete = user.hard_delete.split(",").map(&:to_i)
      hard_delete_array = user_hard_delete

      if user_hard_delete.include?(food_id)
        quantity_id = nil; list_id = nil; delete_food_id = food_id; destroy_entirely = nil
        HardDelete.new(quantity_id, list_id, user_id, delete_food_id, destroy_entirely).undo_hard_delete_user
        hard_delete_array = (user_hard_delete += [food_id]).uniq
      else
        hard_delete_array = user_hard_delete
      end

      if !user_favorites.include?(food_id)
        Favorite.new(food_id, user.id).favorite
        @new_favorite = food_id
        favorites_array = (user_favorites += [food_id]).uniq
      else
        @new_favorite = "already added"
        favorites_array = user_favorites
      end
      @user = user
    else
      Rails.logger.info "{ 'controller' => 'users', 'action' => 'user_favorite', 'user_id' => 'nil', 'food_id' => #{food_id} }"
    end
    #LIKER BOX
    if params[:liker] != nil
      ineligible_array = favorites_array + hard_delete_array
      the_string = ""

      eligible_foods = Food.where.not(id:ineligible_array).where(the_string.gsub(/(.*)( AND )(.*)/, '\1\3')).pluck(:id)
      eligible_foods = Food.where(id:eligible_foods)+Food.where(id:eligible_foods,root_cat_name:"Produce")*10
      @next_like_id = eligible_foods.sample.id
      @next_like_name = Food.find(@next_like_id).name.split.map(&:capitalize).join(' ')
    else
      @next_like_id = nil
    end

    respond_to do |format|
      format.js {}
      format.html { redirect_to head 200, content_type: "text/html" }
    end
  end
  
  def edit
    if current_user != nil
      Rails.logger.info "{ 'controller' => 'users', 'action' => 'edit', 'user_id' => '#{current_user.id}' }"
      @user = User.find(params[:id])
    else
      Rails.logger.info "{ 'controller' => 'users', 'action' => 'edit', 'error' => 'could not edit' }"
      redirect_to root_url
    end
  end
  def update_bio
    @user = User.find(current_user.id)
    if @user.update(user_params)
      head 200, content_type: "text/html"
      Rails.logger.info "{ 'controller' => 'users', 'action' => 'update_bio', 'user_id' => '#{current_user.id}' }"
    else
      render "edit"
      Rails.logger.info "{ 'controller' => 'users', 'action' => 'update_bio', 'error' => 'could not update bio' }"
    end
  end
  def update_settings
    @user = User.find(current_user.id)
    if @user.update(user_params)
      Rails.logger.info "{ 'controller' => 'users', 'action' => 'update_settings', 'user_id' => #{current_user.id} }"
      head 200, content_type: "text/html"
    else
      Rails.logger.info "{ 'controller' => 'users', 'action' => 'update_settings', 'user_id' => 'could not update settings' }"
      render "devise/registrations/edit"
    end
  end
  def update
    @user = User.find(params[:id])
    image = @user.image
    if @user.update_attributes(user_params)
      Rails.logger.info "{ 'controller' => 'users', 'action' => 'update', 'user_id' => '#{current_user.id}' }"
      if image != @user.image
        @user.increment!(:points,1)
        redirect_to @user
      else
        head 200, content_type: "text/html"
      end
    else
      Rails.logger.info "{ 'controller' => 'users', 'action' => 'update', 'error' => 'could not update user' }"
      render 'edit'
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    Rails.logger.info "{ 'controller' => 'users', 'action' => 'destroy', 'user_id' => '#{params[:id]}' }"
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  
  def undo_hard_delete_user
    delete_food_id = params[:param].to_i
    user_id = current_user.id
    list_id = nil; quantity_id = nil; destroy_entirely = nil
    HardDelete.new(quantity_id, list_id, user_id, delete_food_id, destroy_entirely).undo_hard_delete_user
    Rails.logger.info "{ 'controller' => 'users', 'action' => 'undo_hard_delete_user', 'user_id' => #{current_user.id}, 'food_id' => #{delete_food_id} }"
    head 200, content_type: "text/html"
  end

  def hard_delete_user_from_profile
   
    food_id = params[:param].to_i
    food = Food.find(food_id)
    if current_user != nil
      @user = current_user
      user_id = @user.id
      user_hard_delete = @user.hard_delete.split(",").map(&:to_i)
      user_favorites = @user.favorites.split(",").map(&:to_i)

      if user_favorites.include?(food_id)
        favorites_array = (user_favorites += [food_id]).uniq
        Favorite.new(food_id, user_id)
      else
        favorites_array = user_favorites
      end

      if !user_hard_delete.include?(food_id)
        hard_delete_array = (user_hard_delete += [food_id]).uniq
        quantity_id = nil; list_id = nil; delete_food_id = food_id; destroy_entirely = nil
        HardDelete.new(quantity_id, list_id, user_id, delete_food_id, destroy_entirely).hard_delete_user
        @new_dislike = food_id
      else
        hard_delete_array = user_hard_delete
        @new_dislike = nil
      end
    end

    #LIKER BOX
    if params[:liker] != nil
      the_string = ""
      ineligible_array = favorites_array + hard_delete_array
   #   the_string = "(fiber*10>carbohydrates OR carbohydrates*40<calories) AND "
   #   added_sugar = ["nectar","corn starch","syrup","sugar","sweet","honey","fruit juice","concentrate","dextrose", "fructose", "glucose", "lactose", "maltose", "sucrose"]

      eligible_foods = Food.where(the_string.gsub(/(.*)( AND )(.*)/, '\1\3')).pluck(:id) - ineligible_array
      Rails.logger.info "ELIGIBLE FOODS LENGTH IS #{eligible_foods.length}"
      @next_like_id = eligible_foods.sample
      @next_like_name = Food.find(@next_like_id).name.split.map(&:capitalize).join(' ')
    else
      @next_like_id = nil
      Rails.logger.info "{ 'controller' => 'users', 'action' => 'hard_delete_user_from_profile', 'user_id' => #{current_user.id}, 'food_id' => #{food_id}, 'liker' => false }"
    end

    respond_to do |format|
      format.js {}
      format.html { redirect_to root_path }
    end

  end


  def skip_liker
    if params[:from] != nil
      if current_user != nil

        @activity = current_user.activities.build(controller:"users",
                                          action:"skip_liker",
                                          arrived_from: params[:from],
                                            ip: request.remote_ip,
                                            display: 0)
      else
        @activity = Activity.create(user_id: nil,
                                    controller:"users",
                                          action:"skip_liker",
                                          arrived_from: params[:from],
                                            ip: request.remote_ip,
                                            display: 0)
      end
      @activity.save!
    end


    the_string = ""

   # the_string = "(fiber*10>carbohydrates OR carbohydrates*40<calories) AND "
   # added_sugar = ["nectar","corn starch","syrup","sugar","sweet","honey","fruit juice","concentrate","dextrose", "fructose", "glucose", "lactose", "maltose", "sucrose"]
    food_id = params[:param].to_i
    if current_user != nil
      user = current_user

      favorites_array = user.favorites.split(",").map(&:to_i)
      hard_delete_array = user.hard_delete.split(",").map(&:to_i)
      ineligible_array = favorites_array + hard_delete_array + [food_id]

    end

    eligible_foods = Food.where(the_string.gsub(/(.*)( AND )(.*)/, '\1\3')).pluck(:id) - ineligible_array
    @next_like_id = eligible_foods.sample
    @next_like_name = Food.find(@next_like_id).name.split.map(&:capitalize).join(' ')
    respond_to do |format|
      format.js {}
      format.html { redirect_to root_path }
    end
  end



  def undo_favorite
    @food_id = params[:param].to_i
    @user = current_user
    Favorite.new(@food_id, @user.id).undo_favorite
    head 200, content_type: "text/html"
    Rails.logger.info "{ 'controller' => 'users', 'action' => 'undo_favorite', 'user_id' => #{current_user.id}, 'food_id' => #{params[:param]} }"
  end

        private
          

          def user_params
            params.require(:user).permit(:name, 
                                         :email, 
                                         :admin,
                                         :hard_delete,
                                         :favorites,
                                         :provider,
                                         :uid,
                                         :image,
                                         :onboard,
                                         :peapod_access_token,
                                         :peapod_jsessionid,
                                         :bio,
                                         :birthday,
                                         :list_buy_code,
                                         :points,
                                         :instagram,
                                         :website,
                                         :twitter,
                                         settings:[
                                          :guest_list,
                                          :sex,
                                          :activity_level,
                                          :age,
                                          :min_calories,
                                          :max_calories,
                                          :min_fiber,
                                          :min_vitamin_a,
                                          :min_vitamin_c,
                                          :min_calcium,
                                          :min_iron,
                                          :max_sugar,
                                          :max_sodium,
                                          :carbohydrates,
                                          :fat,
                                          :protein,
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
                                          :percentage,
                                          :budget,
                                          :days])
          end
          
          # Before filters

          
          # Confirms the correct user.
          def correct_user
            @user = User.find(params[:id])
            redirect_to(root_url) unless current_user == @user
          end
          
          def admin_user
            redirect_to(root_url) unless current_user.admin?
          end

          def set_s3_direct_post
            if current_user != nil
              if current_user == User.find(params[:id])
                @s3_direct_post = S3_BUCKET.presigned_post(key: "uploads/#{current_user.id}/profile_photo/#{SecureRandom.uuid}/${filename}", success_action_status: '201', acl: 'public-read', content_type: "")
              end
            end
          end
    
end