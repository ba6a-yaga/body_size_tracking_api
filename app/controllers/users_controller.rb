class UsersController < ApplicationController
  def index
    user_id = params[:user][:id]
    auth_token = params[:user][:auth_token]
    if logged_in?(user_id, auth_token)
      user = current_user.attributes.slice("id", "fullname", "email", "waist", "hips", "chest")
      render json: {:token => auth_token, :user => user}
    else
      head :unauthorized
    end
  end

  def create
    @user = User.new(user_params) 
    if @user.save
      token = sign_in @user
      user = @user.attributes.slice("id", "fullname", "email", "waist", "hips", "chest")
      render json: {:token => token, :user => user}, status: :created
    else
      render json: {:errors => @user.errors.messages}, status: :unprocessable_entity
    end
  end

  def update
    user_id = params[:id]
    auth_token = params[:user][:auth_token]
    if logged_in?(user_id, auth_token)
      user = current_user
      user.update_attributes(user_params)
      if user.valid?
        user_slice = user.attributes.slice("id", "fullname", "email", "waist", "hips", "chest")
        render json: {:token => auth_token, :user => user_slice}
      else
        render :json => {:errors => user.errors.messages}, :status => :unprocessable_entity
      end
    else
      head :unauthorized
    end
  end

  def show
    user_id = params[:id]
    auth_token = params[:user][:auth_token]
    if logged_in?(user_id, auth_token)
      if (@user = User.find_by(id: user_id))
        user = @user.attributes.slice("id", "fullname", "email", "waist", "hips", "chest")
        render json: {:token => auth_token, :user => user}
      else
        head :not_found
      end
    else
      head :unauthorized
    end
  end

  private

    def user_params
      params.require(:user).permit(:fullname, :email, :password, 
      :password_confirmation, 
      :waist, :hips, :chest,
      :user_id, :auth_token)
    end
  
end
