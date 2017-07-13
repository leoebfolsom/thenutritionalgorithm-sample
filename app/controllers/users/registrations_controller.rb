class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters
#  before_action :configure_permitted_parameters
#  skip_before_action :require_no_authentication
 # before_action :logged_in_user, only: [:index, :edit, :update, :destroy,
  #                                        :following, :followers]
  #before_action :correct_user,   only: [:edit, :update]
  #before_action :admin_user,     only: :destroy

  def create
    super do
        #resource.tag_list = params[:tags]
        
        if resource.save
        else
          @params = params[:user]
          @params_settings = params[:user]["settings"]
        end
    end
  end
  
  protected


  def update_resource(resource, params)
 #   @user = User.find(current_user.id)
    if params[:password].blank?
      params.delete :current_password
      resource.update_without_password(params)
    else 
      resource.update_with_password(params)
    end
  #  end
   # resource.update_without_password(params)#.except(:password,:password_confirmation))
   # else
  #    if !resource.authenticate(params[:current_password])
   #     render 'edit'
   #   end
  #  end
  end

  def configure_permitted_parameters
        devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(
          :password,
          :password_confirmation,
          :name, 
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
            :min_potassium,
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
            :days,
            :budget]  )}
        devise_parameter_sanitizer.for(:account_update) { |u| u.permit(
          :password,
          :password_confirmation, 
          :current_password,
           :name, 
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
            :min_potassium,
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
            :days,
            :budget]
          )}
      end
end
