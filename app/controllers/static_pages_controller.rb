class StaticPagesController < ApplicationController
  after_action :allow_iframe, only: :iframe
 # before_action :nutrition_init, :only => [:home]
  respond_to :html, :js
  
  include ActionController::Live
  include ActionController::Cookies

  def iframe
    response.headers["X-Frame-Options"] = "ALLOWALL"
  end


  def fun
    if user_signed_in?
      user = current_user
      @the_string = user.settings
    end
  end
  def see_notifications
    if current_user
      Activity.where(user_id_to_be_notified:current_user.id,seen:0).update_all(:seen=>1)
      respond_to do |format|
        format.js {}
        format.html { head 200, content_type: "text/html" }
      end
    end
  end


  def cooking_with_leo
    if current_user != nil
      @activity = current_user.activities.build(controller:"static_pages",
                                            action:"cooking_with_leo",
                                            arrived_from: params[:from],
                                            ip: request.remote_ip,
                                            display: 0)
      @activity.save!
    end
  end

  def home_search

    params_search = params[:search].downcase

    @list_result = List.search_note(params_search).pluck(:id)
    @list_result += List.search_name(params_search).pluck(:id)
    @list_result += Post.search_body(params_search).pluck(:list_id)
    @list_result += Post.search_title(params_search).pluck(:list_id)
    @food_result = Food.home_search(params_search).pluck(:id)
    lists = Quantity.where(food_id:@food_result).pluck(:list_id)
    @list_result += lists
    @list_result = @list_result.flatten.group_by {|i| i}.sort_by {|_, a| -a.count}.map &:first
    @list_result -= [nil]
    @list_result = List.find(@list_result).index_by(&:id).slice(*@list_result).values

    if @list_result.length > 0

      @activity = Activity.create(user_id: current_user.id,
                                    controller:"static_pages",
                                    action:"home_search",
                                    arrived_from: params_search,
                                    ip: request.remote_ip,
                                    display: 0)
      @activity.save!
    else

      @activity = Activity.create(user_id: current_user.id,
                                    controller:"static_pages",
                                    action:"home_search(failed)",
                                    arrived_from: params_search,
                                    ip: request.remote_ip,
                                    display: 0)
      @activity.save!

    end

    respond_to do |format|
      format.js {}
      format.html {head 200, content_type: "text/html"}
    end

  end



  def home





   # @grid_images = Image.where.not(id:31).reverse.first(20)

    @dishes = Post.joins(:images).order("created_at DESC").uniq
    

    
    if user_signed_in?

      @feed_items = current_user.feed#paginate(page: params[:page])
      #@posts_feed_items = current_user.posts_feed.order("updated_at DESC")


      @activities = Activity.where(is_notification:nil).where(display:1).order("created_at DESC").first(20)

      @activity = current_user.activities.build(controller:"static_pages",
                                            action:"home",
                                            arrived_from: params[:from],
                                            ip: request.remote_ip,
                                            display: 0)
      @activity.save!

      Rails.logger.info "{ 'controller' => 'static_pages', 'action' => 'home', 'user_id' => '#{current_user.id}' } "

      @onboard = current_user.onboard
      if @onboard != "Z"
    
        @user_favorites = []#current_user.favorites.split(",").map(&:to_i)
        user_hard_delete = []#current_user.hard_delete.split(",").map(&:to_i)
        user_favorites_plus_hard_deletes = []#@user_favorites + user_hard_delete
      end
      if List.where(user_id:current_user.id).length != 0
        @user = User.joins(:lists).find(current_user.id)
      else
        @user = current_user
      end

    end
  end

  def static_chart_generate
    respond_to do |format|
      format.js {}
      format.html { redirect_to head 200, content_type: "text/html" }
    end
  end

  def list_preview
    @list_id = params[:list_id]
    respond_to do |format|
      format.js {}
      format.html { head 200, content_type: "text/html" }
    end
  end

  def onboarding_favorite
    food_id = params[:param].to_i
    user = current_user
    Rails.logger.info "{ 'controller' => 'static_pages', 'action' => 'onboarding_favorite', 'user_id' => '#{current_user.id}' } "

    Favorite.new(food_id, user.id).favorite

    user.update_attribute(:onboard,"Z")
    
    head 200, content_type: "text/html"
  end


  def skip_onboarding
    current_user.update_attribute(:onboard,"Z")
    user = current_user
    Rails.logger.info "{ 'controller' => 'static_pages', 'action' => 'skip_onboarding', 'user_id' => '#{current_user.id}' } "
   # redirect_to addlist_path(:first_list=>true)
    user_settings = user.settings
    list_days = user_settings["days"].to_i
    max_price = user_settings["budget"].to_i
    percentage = user_settings["percentage"].to_i
    age = user_settings["age"].to_i
    gender = user_settings["sex"]
    min_fiber = user_settings["min_fiber"].to_i
    min_vitamin_a = user_settings["min_vitamin_a"].to_i
    min_vitamin_c = user_settings["min_vitamin_c"].to_i
    min_iron = user_settings["min_iron"].to_i
    min_calcium = user_settings["min_calcium"].to_i
    max_sodium = user_settings["max_sodium"].to_i
    height = user_settings["height"].to_i
    weight = user_settings["weight"].to_i
    activity_level = user_settings["activity_level"]
    carbohydrates_percentage = user_settings["carbohydrates"].to_i
    fat_percentage = user_settings["fat"].to_i
    protein_percentage = user_settings["protein"].to_i
    min_calories = user_settings["min_calories"].to_i
    max_calories =  user_settings["max_calories"].to_i
    user.increment!(:points,5)
    if (list_days == 0 ||
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
      redirect_to user_path(user)

    else
      redirect_to root_path
    end
  end

  def charts
    Activity.where(action:"build_list").each do |l|
      if Quantity.where(list_id:l.list_id).length != 0
        l.update_attribute(:attribute_updated,nil)
        l.save!
      else
        l.update_attribute(:attribute_updated,"empty")
        l.save!
      end
    end
  end
  
  def about
    Rails.logger.info "The IP is"
    Rails.logger.info request.remote_ip
    if logged_in?
      Rails.logger.info "{ 'controller' => 'static_pages', 'action' => 'about', 'user_id' => '#{current_user.id}' } "
    else
      Rails.logger.info "{ 'controller' => 'static_pages', 'action' => 'about', 'user_id' => 'nil' } "
    end
  end
  
  def contact
    if logged_in?
      Rails.logger.info "{ 'controller' => 'static_pages', 'action' => 'contact', 'user_id' => '#{current_user.id}' } "
    else
      Rails.logger.info "{ 'controller' => 'static_pages', 'action' => 'contact', 'user_id' => 'nil' } "
    end
  end



      private

      def allow_iframe
        response.headers['X-Frame-Options'] = "ALLOWALL"
      end

  
end
