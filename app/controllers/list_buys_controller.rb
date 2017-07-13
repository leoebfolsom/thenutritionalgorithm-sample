class ListBuysController < ApplicationController
  before_action :correct_user,   only: [:destroy]
  before_action :set_s3_direct_post, only: [:show, :create, :edit, :update]
  respond_to :html, :js

  def index
    @list_buys = ListBuy.paginate(page: params[:page]).order('created_at DESC')
  end  


  def show
    @list_buy = ListBuy.find(params[:id])
  end
  
  def new
    @list_buy = ListBuy.new
    @list_id = params[:list_id]
    @user_id = params[:user_id]
    @list_buy_code = params[:list_buy_code]
    if User.exists?(@user_id) && List.exists?(@list_id)
      if @list_buy_code != User.find(@user_id).list_buy_code
        redirect_to root_url
      end
    else
      redirect_to root_url
    end

  end
  def create
    @list_buy = ListBuy.new(list_buy_params)
    flash[:success] = "There was an error in saving your checklist. Please make sure the fields contain numbers, not words."
    if @list_buy.save


      if current_user != nil
        @activity = current_user.activities.build(controller:"list_buys",
                                          action:"create_list_buy",
                                          arrived_from: params[:from],
                                          ip: request.remote_ip,
                                          display: 0,
                                          list_id: @list_buy.list.id,
                                          user_id: @list_buy.user.id)
      else
        @activity = User.find(@list_buy.user.id).activities.build(controller:"list_buys",
                                          action:"create_list_buy",
                                          arrived_from: params[:from],
                                          ip: request.remote_ip,
                                          display: 0,
                                          list_id: @list_buy.list.id,
                                          user_id: @list_buy.user.id)
      end
      @activity.save!
      current_user.increment!(:points,5)
      if current_user != @list_buy.list.user
        @list_buy.list.user.increment!(:points,5)
      end
      ListbuyMailer.listbuy_mailer(@list_buy.list.id, @list_buy.list.user.id, @list_buy.user.id).deliver_now
      respond_to do |format|
        format.js {}
        format.html {redirect_to @list_buy}
      end

    else
      redirect_to :action => "new", :list_id => @list_buy.list_id, :user_id => @list_buy.user_id, :list_buy_code => params[:list_buy_code], :error => true
    end
  end



  def edit
    @list_buy = ListBuy.find(params[:id])
  end

  def update

    @list_buy = ListBuy.find(params[:id])
    if @list_buy.update_attributes(list_buy_params)
      flash[:success] = "The list_buy has been updated."
      redirect_to @list_buy
    else
      flash[:success] = "The list_buy was not updated."
      redirect_to @list_buy
    end
  end
  
  def destroy
    ListBUy.find(params[:id]).destroy
    head 200, content_type: "text/html"
  end
  


private


    def list_buy_params
      params.require(:list_buy).permit(:list_id, 
                                       :user_id,
                                       :receipt_image,
                                       :total_price,
                                       :total_calories,
                                       :total_carbohydrates,
                                       :total_fat,
                                       :total_protein,
                                       :total_fiber,
                                       :total_vitamin_a,
                                       :total_vitamin_c,
                                       :total_iron,
                                       :total_calcium,
                                       :total_sodium,
                                       :total_sugar)
    end

    def correct_user
      @list_buy = current_user.list_buys.find_by(id: params[:id])
      redirect_to root_url if @list_buy.nil?
    end
    def set_s3_direct_post
      @s3_direct_post = S3_BUCKET.presigned_post(key: "uploads/list_buys/#{params[:id]}/#{SecureRandom.uuid}/${filename}", success_action_status: '201', acl: 'public-read', content_type: "")
    end

end