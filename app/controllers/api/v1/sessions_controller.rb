class Api::V1::SessionsController < Devise::SessionsController
  # the prepend filter will run at first for user creation,skipping default require authentication scope 
  prepend_before_filter :require_no_authentication, :only => [:create ]
  #checking mandatory user parameter at the time of user creation
  before_filter :ensure_params_exist, only: :create
  #only respond to json format
  respond_to :json

  #user login
  def create
    resource = User.find_by(:email=>params[:email])
    return invalid_login_attempt unless resource

    if resource.valid_password?(params[:password])
      sign_in("user", resource)
      render json: {success: true, auth_token: resource.authentication_token, email: resource.email}
      return
    end
    invalid_login_attempt
  end
  
  #user logout
  def destroy
    sign_out(resource_name)
  end

  protected
   def ensure_params_exist
    return unless params[:email].blank?
    render json: {success: false, message: "missing user_login parameter"}, status: 422
   end
 
   def invalid_login_attempt
    warden.custom_failure!
    render json: {success: false, message: "Error with your login or password"}, status: 401
   end
end
