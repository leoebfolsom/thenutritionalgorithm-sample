class ApplicationController < ActionController::Base
  before_action :block_ip_addresses
  require 'csv'
#  before_action :configure_permitted_parameters, if: :devise_controller?


  def random_list_name
    all = CSV.read('db/names.csv')
    length = all.length
    n = 0
    m = rand(length)
    o = 1
    p = rand(length)
    q = 2
    r = rand(length)
    s = 3
    t = rand(length)
    all[m][n]+" "+all[p][o]+" "+all[r][q]+" "+all[t][s]
  end




  def auto_instagram (s)
    data = "<i class='fa fa-2x fa-instagram' aria-hidden='true'></i> <a href="+"http://instagram.com/"+s.gsub("@","")+" target='_blank'>@"+s.gsub("@","")+"</a>"
    data.html_safe
  end

  def auto_twitter (s)
    data = "<i class='fa fa-2x fa-twitter' aria-hidden='true'></i> <a href="+"http://twitter.com/"+s.gsub("@","")+" target='_blank'>@"+s.gsub("@","")+"</a>"
    data.html_safe
  end



  def age_in_completed_years (bd, d)
      # Difference in years, less one if you have not had a birthday this year.
      a = d.year - bd.year
      a = a - 1 if (
           bd.month >  d.month or 
          (bd.month >= d.month and bd.day > d.day)
      )
      a
  end
  helper_method :age_in_completed_years
  helper_method :random_list_name
  helper_method :auto_instagram
  helper_method :auto_twitter


 # before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!, if: :devise_controller?
  include FoodsHelper
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from ActiveRecord::RecordNotFound, with: :render_404
 # rescue_from ActiveRecord::RecordNotFound do |exception|
 #   render_404
 # end

  include SessionsHelper
  
  private

  def block_ip_addresses
    head :unauthorized if request.remote_ip == redacted
  end

      def logged_in_user
        unless logged_in?
          store_location
          flash[:danger] = "Please log in."
          redirect_to root_url
        end
      end


      def nutrition_init
        if params[:id] == nil && current_user == nil
          if Image.count > 0
            @list_id = Image.all.sample.post.list_id
            @list = List.find(@list_id)
            list = @list
          end
        elsif params[:id] != nil
          @list_id = params[:id]
          list = List.find(@list_id)
          @list = list
        end
        if params[:id] != nil || current_user == nil
          @constraints = list.nutrition_constraints
          @list_users = @constraints["list_users"]
          @list_days = @list.days
          @list_age = @list.age
          @list_sex = @list.gender
          @list_percentage = @list.percentage
          @list_activity_level = @constraints["activity_level"]
          @min_cal_day = @constraints["min_calories"].to_i
          @max_cal_day = @constraints["max_calories"].to_i
          @min_fiber_day = @constraints["min_fiber"].to_i
          @max_sodium_day = @constraints["max_sodium"].to_i
          @max_sugar_day = @constraints["max_sugar"].to_i
          @min_vitamin_a_day = @constraints["min_vitamin_a"].to_i
          @max_vitamin_a_day = @constraints["max_vitamin_a"].to_i
          @min_vitamin_c_day = @constraints["min_vitamin_c"].to_i
          @max_vitamin_c_day = @constraints["max_vitamin_c"].to_i
          @min_iron_day = @constraints["min_iron"].to_i
          @max_iron_day = @constraints["max_iron"].to_i
          @min_calcium_day = @constraints["min_calcium"].to_i
          @max_calcium_day = @constraints["max_calcium"].to_i
          @list_height = @constraints["height"].to_i
          @list_weight = @constraints["weight"].to_i    
          @list_user_name = @list.user.name
          @carbohydrates_percentage = @constraints["carbohydrates"].to_i
          @fat_percentage = @constraints["fat"].to_i
          @protein_percentage = @constraints["protein"].to_i
          @min_protein_day = @constraints["min_protein"].to_i
          @max_protein_day = @constraints["max_protein"].to_i
          @min_fat_day = @constraints["min_fat"].to_i
          @max_fat_day = @constraints["max_fat"].to_i
          @min_carbohydrates_day = @constraints["min_carbohydrates"].to_i
          @max_carbohydrates_day = @constraints["max_carbohydrates"].to_i  
          if @list_users != nil && @list_users.length > 0
            @list_users.keys.each do |l|
              @min_cal_day += @list_users[l]["min_calories"].to_i
              @max_cal_day += @list_users[l]["max_calories"].to_i
              @min_carbohydrates_day += @list_users[l]["min_carbohydrates"].to_i
              @max_carbohydrates_day += @list_users[l]["max_carbohydrates"].to_i
              @min_fat_day += @list_users[l]["min_fat"].to_i
              @max_fat_day += @list_users[l]["max_fat"].to_i
              @min_protein_day += @list_users[l]["min_protein"].to_i
              @max_protein_day += @list_users[l]["max_protein"].to_i
              @min_iron_day += @list_users[l]["min_iron"].to_i
              @max_iron_day += @list_users[l]["max_iron"].to_i
              @min_calcium_day += @list_users[l]["min_calcium"].to_i
              @max_calcium_day += @list_users[l]["max_calcium"].to_i
              @min_vitamin_a_day += @list_users[l]["min_vitamin_a"].to_i
              @max_vitamin_a_day += @list_users[l]["max_vitamin_a"].to_i
              @min_vitamin_c_day += @list_users[l]["min_vitamin_c"].to_i
              @max_vitamin_c_day += @list_users[l]["max_vitamin_c"].to_i
              @max_sodium_day += @list_users[l]["max_sodium"].to_i
              @max_sugar_day += @list_users[l]["max_sugar"].to_i
              @min_fiber_day += @list_users[l]["min_fiber"].to_i
            end
          end

          @min_protein = @min_protein_day * @list_days
          @max_protein = @max_protein_day * @list_days
          @min_fat = @min_fat_day * @list_days
          @max_fat = @max_fat_day * @list_days
          @min_carbohydrates = @min_carbohydrates_day * @list_days
          @max_carbohydrates = @max_carbohydrates_day * @list_days

          @progress_min_calories = (((@list.total_calories.to_f/@list_days)/@min_cal_day)*100).round
          @progress_max_calories = (((@list.total_calories.to_f/@list_days)/@max_cal_day)*100).round
          if @progress_min_calories < 100
            @progress_calories = @progress_min_calories.round
          elsif @progress_max_calories > 100
            @progress_calories = @progress_max_calories.round
          else
            @progress_calories = 100
          end
          
          @progress_fiber = (((@list.total_fiber.to_f/@list_days)/@min_fiber_day)*100).round
          @progress_sodium = (((@list.total_sodium.to_f/@list_days)/@max_sodium_day)*100).round

          @progress_min_vitamin_a = (((@list.total_vitamin_a.to_f/@list_days)/@min_vitamin_a_day)*100).round
          @progress_max_vitamin_a = (((@list.total_vitamin_a.to_f/@list_days)/@max_vitamin_a_day)*100).round
          if @progress_min_vitamin_a < 100
            @progress_vitamin_a = @progress_min_vitamin_a.round
          elsif @progress_max_vitamin_a > 100
            @progress_vitamin_a = @progress_max_vitamin_a.round
          else
            @progress_vitamin_a = 100
          end

          @progress_min_vitamin_c = (((@list.total_vitamin_c.to_f/@list_days)/@min_vitamin_c_day)*100).round
          @progress_max_vitamin_c = (((@list.total_vitamin_c.to_f/@list_days)/@max_vitamin_c_day)*100).round
          if @progress_min_vitamin_c < 100
            @progress_vitamin_c = @progress_min_vitamin_c.round
          elsif @progress_max_vitamin_c > 100
            @progress_vitamin_c = @progress_max_vitamin_c.round
          else
            @progress_vitamin_c = 100
          end

          @progress_min_iron = (((@list.total_iron.to_f/@list_days)/@min_iron_day)*100).round
          @progress_max_iron = (((@list.total_iron.to_f/@list_days)/@max_iron_day)*100).round
          if @progress_min_iron < 100
            @progress_iron = @progress_min_iron.round
          elsif @progress_max_iron > 100
            @progress_iron = @progress_max_iron.round
          else
            @progress_iron = 100
          end

          @progress_min_calcium = (((@list.total_calcium.to_f/@list_days)/@min_calcium_day)*100).round
          @progress_max_calcium = (((@list.total_calcium.to_f/@list_days)/@max_calcium_day)*100).round
          if @progress_min_calcium < 100
            @progress_calcium = @progress_min_calcium.round
          elsif @progress_max_calcium > 100
            @progress_calcium = @progress_max_calcium.round
          else
            @progress_calcium = 100
          end

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
        end
      end


      def render_404
        render file: 'public/404', status: :not_found, :formats => [:html]
      end


end
