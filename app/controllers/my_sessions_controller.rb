class MySessionsController < Devise::SessionsController
  before_action :authenticate_user!
end
