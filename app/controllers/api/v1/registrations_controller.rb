class Api::V1::RegistrationsController < Devise::RegistrationsController
 
  respond_to :json

  # crete user with authentication token generated
  def create 
  	user = User.new(user_params)
    if user.save
    render json:  user.as_json(auth_token: user.authentication_token, email: user.email, role: user.role), status: 201
    return
	else
	warden.custom_failure!
	render json: user.errors, status: 422
	end
  end

  private
 
  def user_params
	params.require(:user).permit(:email, :password, :password_confirmation,:role)
  end

end
