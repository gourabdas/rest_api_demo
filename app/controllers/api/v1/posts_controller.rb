class Api::V1::PostsController < Api::V1::ApplicationController
	before_action :authenticate_with_token!
    authorize_resource

	# post creation by a particular user 
	def create
		post = @current_user.posts.create(post_params) 
		if post.save
		render json: {success: true, auth_token: @current_user.authentication_token, post_id: post.id}
	    else
	    render json: {success: false, errors: post.errors.full_messages, message: "Validation failed"}, status: 422
		end 
	end
     
    # post updation by a particular user 
	def update	
		post = @current_user.role == "admin" ? Post.find_by(id: params[:id]) : @current_user.posts.find_by(id: params[:id]) 
		if post && post.update_attributes(post_params)
		render json: {success: true, auth_token: @current_user.authentication_token, post_id: post.id, post_desc: post.description}
	    else
	    render json: {success: false,  message: "not found or validation failed"}, status: 422
		end 
	end

	# get post details for a particular id
	def show
		post = Post.find_by(id: params[:id])
		if post
		render json: {success: true, auth_token: @current_user.authentication_token, post_desc: post.description}
		else
		render json: {success: false, message: "Not found"}, status: 404
		end
	end
    
    # post destroy by a particular user
	def destroy
		post = @current_user.role == "admin" ? Post.find_by(id: params[:id]) : @current_user.posts.find_by(id: params[:id])
		if post
		 post.destroy
		 render json: {success: true, message: "Successfully destroyed"}, status: 200
		else
         render json: {success: true, message: "Not found"}, status: 404
		end
	end

	private
	def post_params
		params.require(:post).permit(:description)
	end

end
