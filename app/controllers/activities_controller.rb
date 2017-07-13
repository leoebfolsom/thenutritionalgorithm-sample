class ActivitiesController < ApplicationController
  before_action :activities_index,   only: [:index]
  respond_to :html, :js

  def new
    @activity = Activity.new

  end

  def index
    #DON'T LOOK AT THE BOTS
    @activities =  Activity.where("ip NOT ILIKE '%66.249.79.%' AND ip NOT ILIKE '%157.55.39%' AND ip NOT ILIKE '%66.249.64.%' AND ip NOT ILIKE '%40.77.167.%' AND ip NOT ILIKE '%207.46.13.%' AND ip NOT ILIKE '%180.76.15.%' AND ip NOT ILIKE '%40.85.188.%' AND ip NOT ILIKE '%66.249.66.%' AND (user_id NOT IN (2,265) OR action ILIKE '%search%' OR user_id IS NULL)").order('created_at DESC').paginate(page: params[:page], :per_page => 100)
  end 

  def create
    @activity = Activity.new(activity_params)
    head 200, content_type: "text/html"
  end

  def like 
    if current_user != nil
      @comment_id = params[:comment_id]
      @user_to_be_notified = params[:user_to_be_notified_id]
      if Activity.where(action:"like",comment_id:@comment_id.to_i,user_id:current_user.id).count == 0

        @activity = current_user.activities.build(controller:"activities",
                                              action:"like",
                                              comment_id: @comment_id,
                                              post_id: params[:post_id],
                                              ip: request.remote_ip)
        @activity.save!
        if current_user.id.to_i != @user_to_be_notified.to_i
          notification = @activity.dup
          notification.update_attributes!(:user_id_to_be_notified => @user_to_be_notified, :seen => 0, :is_notification => 1)
        end
        @new_comment_like_count = Activity.where(is_notification:nil,action:"like",comment_id:@comment_id.to_i).count
        respond_to do |format|
          format.js {}
          format.html { head 200, content_type: "text/html" }
        end
      end
      
    end
  end

  private

    def activity_params
      params.require(:activity).permit(:user_id,
                                  :controller,
                                  :action,
                                  :arrived_from,
                                  :list_id,
                                  :attribute_updated,
                                  :forked_list_id,
                                  :display,
                                  :ip,
                                  :viewed_user_id,
                                  :image_id,
                                  :post_id,
                                  :comment_id,
                                  :seen,
                                  :is_notification,
                                  :user_id_to_be_notified)
    end
    def activities_index
      if current_user != nil
        auth = (current_user.id == redacted || current_user.admin)
        redirect_to root_url if (auth != true)
      else
        redirect_to root_url
      end
    end
end