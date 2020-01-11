class UsersController < ApplicationController
  before_action :check_header, only: [:index, :update, :show]
  before_action :check_user_id, only: [:index, :update, :show]
  after_action :add_headers, only: [:index, :update, :show, :create]

  def index
    if logged_in?
      user = current_user.attributes.slice("id", "fullname", "email", "waist", "hips", "chest")
      render json: {:user => user}
    else
      head :unauthorized
    end
  end

  def create
    @user = User.new(user_params) 
    if @user.save
      sign_in @user
      user = @user.attributes.slice("id", "fullname", "email", "waist", "hips", "chest")
      render json: {:user => user}, status: :created
    else
      render json: {:errors => @user.errors.messages}, status: :unprocessable_entity
    end
  end

  def update
    if logged_in?
      user = current_user
      user.update_attributes(user_params)
      if user.valid?
        user_slice = user.attributes.slice("id", "fullname", "email", "waist", "hips", "chest")
        render json: {:user => user_slice}
      else
        render :json => {:errors => user.errors.messages}, :status => :unprocessable_entity
      end
    else
      render :json => {:auth_token => @auth_token, :user_id => @user_id, :header_token => request.headers["X-BDS-M-AUTH-TOKEN"], :header_user_id => request.headers["X-BDS-M-USER-ID"]}, :status => :unauthorized
    end
  end

  def show
    if logged_in?
      if (@user = User.find_by(id: @user_id))
        user = @user.attributes.slice("id", "fullname", "email", "waist", "hips", "chest")
        render json: {:user => user}
      else
        head :not_found
      end
    else
      head :unauthorized
    end
  end

  def body_sizing
    
  end

  private

    def user_params
      params.require(:user).permit(:fullname, :email, :password, 
      :password_confirmation, 
      :waist, :hips, :chest)
    end
  
end
