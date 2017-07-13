class PostsController < ApplicationController

  before_action :correct_user,   only: [:destroy, :edit]
  respond_to :html, :js

  def index
    @posts = Post.paginate(page: params[:page]).order('created_at DESC')
  end  


  def show
    @post = Post.find(params[:id])
  end
  
  def new
    @post = Post.new
  end
  def create
    @post = Post.new(post_params)
    if current_user == @post.list.user || post_params["user_id"] == "75"
      if @post.save
        if current_user

          @activity = current_user.activities.build(controller:"posts",
                                              action:"create",
                                              arrived_from: params[:from],
                                              ip: request.remote_ip,
                                              display: 1,
                                              post_id: @post.id,
                                              list_id: @post.list.id,
                                              user_id: @post.user.id)
          @activity.save!

          current_user.increment!(:points,10)
        end
        respond_to do |format|
          format.js {}
          format.html {head 200, content_type: "text/html"}
        end
      else
        render 'new'
      end
    else
      redirect_to root_url
    end
  end



  def edit
    @post = Post.find(params[:id])
  end

  def update

    @post = Post.find(params[:id])
    if @post.user == current_user || @post.list.user.id == 75
      if @post.update_attributes(post_params)
        flash[:success] = "The post has been updated."
        redirect_to "http://www.thenutritionalgorithm.com/lists/"+@post.list.id.to_s+"/#dish-"+@post.id.to_s
        Activity.where(post_id:params[:id],comment_id:nil).update_all(:display=>0)
        if current_user
          @activity = current_user.activities.build(controller:"posts",
                                              action:"update",
                                              arrived_from: params[:from],
                                              ip: request.remote_ip,
                                              display: 1,
                                              post_id: @post.id,
                                              list_id: @post.list.id,
                                              user_id: @post.user.id)
          @activity.save!
        end
        

      else
        render 'edit'
      end
    else
      redirect_to root_url
    end
  end
  
  def destroy
    Activity.where(post_id:params[:id]).update_all(:display=>0)
    Post.find(params[:id]).destroy
 #   redirect_to root_path, status: 303
    head 200, content_type: "text/html"
  end
  


private


    def post_params
      params.require(:post).permit(:list_id, 
                                       :user_id,
                                       :body,
                                       :title,
                                       :original_author,
                                       :parent_dish,
                                       :instagram_user,
                                       :instagram_user_url,
                                       :instagram_url)
    end

    def correct_user



      if current_user
        @post = current_user.posts.find_by(id: params[:id])
        redirect_to root_url if @post.nil?
      else
        if Post.exists?(params[:id])
          if Post.find(params[:id]).list.user.id != 75
            Rails.logger.info "was not 75"
            redirect_to root_url
          end
        end
      end


    end

end