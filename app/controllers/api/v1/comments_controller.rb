class Api::V1::CommentsController < Api::V1::ApplicationController
	before_action :authenticate_with_token!
	load_and_authorize_resource 
    before_action :find_post, except: [:create]


    # comment creation for a particular post by a particular user
	def create
	  post = @current_user.role == 'admin' || 'user' ? Post.find_by(id: params[:post_id]) : @current_user.posts.find_by(id: params[:post_id])
      comment = post.comments.new(comment_params)
      comment.user_id = @current_user.id
      if comment.save
      render json: {success: true, auth_token: @current_user.authentication_token, comment_id: comment.id, post_id: comment.post_id}
      else
      render json: {success: false, errors: comment.errors.full_messages, message: "Validation failed"}, status: 422
      end
	end

    # comment update for a particular post by a particular user
	def update
      comment = @post.comments.find_by(id: params[:id])
      if comment && comment.update_attributes(comment_params)
      render json: {success: true, auth_token: @current_user.authentication_token, comment_id: comment.id, post_id: comment.post_id}
      else
      render json: {success: false, message: "not found or validation failed"}, status: 422
      end
	end

	#get comment details for a particular comment
	def show
		comment = Comment.find_by(id: params[:id])
		if comment
	    render json: {success: true, auth_token: @current_user.authentication_token, comment_id: comment.id, comment_desc: comment.desc}
		else
        render json: {success: false, message: "Not found"}, status: 404		
        end
	end

	# comment destroy for a partilcar post given by the user
	def destroy
		comment =  @post.comments.find_by(id: params[:id])
		if comment
		   comment.destroy
		   render json: { success: true, message: "Successfully destroyed"}, status: 200
		else
		  render json: { success: true, message: "Not found"}, status: 404
		end
	end

	private

	def find_post
		@post = @current_user.role == "admin" ? Post.find_by(id: params[:post_id]) : @current_user.posts.find_by(id: params[:post_id])
		render json: { errors: "Not found" }, status: 404 unless @post.present?                
	end

	def comment_params
		params.require(:comment).permit(:post_id,:desc)
	end
end
