class SubscribeController < ApplicationController
  before_action :authenticate_user! 
  def new 
  end 
  def update 
    # Get the credit card details submitted by the form 
    token = params[:stripeToken] 


    if params[:plan_id]
      plan_id = params[:plan_id]
    else
      plan_id = 'member-plan'
    end
    plan = Stripe::Plan.retrieve(plan_id)


    # Create a Customer 
    customer = Stripe::Customer.create( 
      :source => token, 
      :plan => plan,
      :email => current_user.email 
    ) 
    # Save stripe information to the current user using Devise     

    current_user.subscribed = true 
    current_user.stripeid = customer.id 
    current_user.save!
    # Redirect back to products page with a 'success' notice 

    StripeMailer.stripe_mailer(current_user.id,"subscribe").deliver_now
    redirect_to root_path, :notice => "Thank you for joining the nutrition algorithm! You are a leader in eating good, healthy, affordable food."

  end



  def cancel_subscription
    subscription_id = Stripe::Customer.retrieve(current_user.stripeid).subscriptions['data'][0].id
    Stripe::Subscription.retrieve(subscription_id).delete
    current_user.update_attributes!(:stripeid => nil, :subscribed => false)
    StripeMailer.stripe_mailer(current_user.id,"cancele").deliver_now
    redirect_to root_path, :notice => "Your subscription was 
    successfully cancelled. You can still access your profile and all list that you have ever created. Please come back soon!"
  end
end
