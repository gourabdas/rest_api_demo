class Api::V1::ApplicationController < ActionController::Base

  protect_from_forgery with: :null_session

  rescue_from CanCan::AccessDenied do |exception|
  render json: { errors: "Not authorized to perform such operation" },status: :unauthorized
  end
 
  private
  
  # Devise methods overwrites
  def current_user
    @current_user ||= User.find_by(authentication_token: request.headers['Authorization'])
  end
 
 
  def authenticate_with_token!
    render json: { errors: "Not authenticated" },
                status: :unauthorized unless current_user.present?
  end

end
