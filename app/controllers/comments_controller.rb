class CommentsController < ApplicationController
  
  def new
    @comment = Comment.new
  end
  def index
    @commentable = find_commentable
    @comments = @commentable.comments
  end

  def create
    @post_id = params[:comment][:commentable_id]
    @commentable = Post.find(@post_id)
    @comment = @commentable.comments.build(content:params[:comment][:content],user_id:params[:comment][:user_id])
    if current_user
      if params[:comment][:user_id].to_i == current_user.id
        if @comment.save
          @activity = current_user.activities.build(controller:"comments",
                                                action:"create",
                                                arrived_from: params[:from],
                                                ip: request.remote_ip,
                                                display: 1,
                                                post_id: @post_id,
                                                list_id: @commentable.list.id,
                                                comment_id: @comment.id)
          @activity.save!
          @commentable.comments.pluck(:user_id).push(@commentable.user.id).uniq.each do |n|

            if current_user.id.to_i != n
              notification = @activity.dup
              notification.update_attributes!(:user_id_to_be_notified => n, :seen => 0, :is_notification => 1)
            end

          end
          
          respond_to do |format|
            format.js {}
            format.html {head 200, content_type: "text/html"}
          end
        else
          render 'new'
        end
      end
    end
  end

  def edit
    @comment = Comment.find(params[:id])
  end

  def update
    @comment = Comment.find(params[:id])
    if @comment.update_attributes(comment_params)
      redirect_to :id => nil
    else
      render 'edit'
    end
  end
  
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    redirect_to @list
  end
  
  private
    def comment_params
      params.require(:comment).permit(:user_id,
                                       :content,
                                       :commentable_type,
                                       :commentable_id)
    end
    def find_commentable
      params.each do |name, value|
        if name =~ /(.+)_id$/
          return $1.classify.constantize.find(value)
        end
      end
      nil
    end
end