module Api::V1
  class ApiController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, :with => :request_not_found

    before_action :authenticate_user_from_token!
    before_action :authenticate_user!

    def invalid_request
      @response = Hash.new

      @response[:message] = "Invalid request"
      @response[:code] = 400
      @response[:help] = "Invalid request. Please check the docs. ERR: 001"

      return render json: @response, status: 400
    end

    def request_not_found
      @response = Hash.new

      @response[:message] = "Invalid request"
      @response[:code] = 404
      @response[:help] = "Invalid request. Please check the docs. ERR: 002"

      return render json: @response, status: 404
    end

    private

    def authenticate_user_from_token!
      user_email = params[:user_email].presence
      user = user_email && User.find_by_email(user_email)

      if user && Devise.secure_compare(user.authentication_token, params[:user_token])
        sign_in user, store: false
      end
    end
  end
end