class ImagesController < ApplicationController

  before_action :correct_user,   only: [:destroy, :edit, :update]
  before_action :set_s3_direct_post, only: [:show, :new, :edit, :update, :create]
  respond_to :html, :js

  def index
    @images = Image.paginate(page: params[:page]).order('created_at DESC')
  end  


  def show
    @image = Image.find(params[:id])
  end
  
  def new
    @post_id = params[:post_id]
    @image = Image.new
  end
  def create
    @image = Image.new(image_params)
    old_url = @image.image_url; 
    new_url = old_url.gsub("tna-main.s3.amazonaws.com","d1esj6dpdcntt5.cloudfront.net")
    @image.update_attribute(:image_url,new_url)

    if current_user == @image.post.user || @image.post.user.id == 75
      if @image.save
        if current_user
          @activity = current_user.activities.build(controller:"images",
                                            action:"create",
                                            arrived_from: params[:from],
                                            ip: request.remote_ip,
                                            display: 1,
                                            image_id: @image.id,
                                            post_id: @image.post.id,
                                            list_id: @image.post.list.id,
                                            user_id: @image.post.user.id)
          @activity.save!
          current_user.increment!(:points,7)
        end
        respond_to do |format|
          format.js {}
          format.html {redirect_to "http://www.thenutritionalgorithm.com/lists/"+@image.post.list.id.to_s+"/#dish-"+@image.post.id.to_s }
        end
      else
        render 'new'
      end
    else
      redirect_to root_url
    end
  end

  def edit
    @image = Image.find(params[:id])
  end

  def update

    @image = Image.find(params[:id])
    if @image.post.user == current_user || @image.post.user.id == 75
      if @image.update_attributes(image_params)

        old_url = @image.image_url; 
        new_url = old_url.gsub("tna-main.s3.amazonaws.com","d1esj6dpdcntt5.cloudfront.net")
        @image.update_attribute(:image_url,new_url)
        
        redirect_to @image.post.list
        Activity.where(image_id:params[:id]).update_all(:display=>0)
        if current_user
          @activity = current_user.activities.build(controller:"images",
                                              action:"update",
                                              arrived_from: params[:from],
                                              ip: request.remote_ip,
                                              display: 1,
                                              image_id: @image.id,
                                              post_id: @image.post.id,
                                              list_id: @image.post.list.id,
                                              user_id: @image.post.user.id)
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
    image = Image.find(params[:id])
    Activity.where(image_id:params[:id]).update_all(:display=>0)
  #  list = image.post.list
    image.destroy
 #   redirect_to list
    head 200, content_type: "text/html"
  end
  


private


    def image_params
      params.require(:image).permit(:post_id, 
                                       :caption,
                                       :image_url)
    end

    def correct_user
      post_id = params[:post_id] 
      if post_id == nil
        if params[:image]
          post_id = params[:image]["post_id"].to_i
        else
          post_id = Image.find(params[:id]).post_id
        end
      end
      @post = current_user.posts.find_by(id: post_id)
      redirect_to root_url if @post.nil?
    end

      def set_s3_direct_post
        if current_user
          @s3_direct_post = S3_BUCKET.presigned_post(key: "uploads/#{current_user.id}/images/post-#{params[:post_id]}/#{SecureRandom.uuid}/${filename}", success_action_status: '201', acl: 'public-read', content_type: "")
        else
          if User.find(75).posts.find_by(id: params[:post_id])
            @s3_direct_post = S3_BUCKET.presigned_post(key: "uploads/75/images/post-#{params[:post_id]}/#{SecureRandom.uuid}/${filename}", success_action_status: '201', acl: 'public-read', content_type: "")
          end
        end
      end

end