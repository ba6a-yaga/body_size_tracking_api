class UsersController < ApplicationController
  before_action :check_header, only: [:index, :update, :show, :body_sizing]
  before_action :check_user_id, only: [:index, :update, :show, :body_sizing]
  after_action :add_headers, only: [:create]

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
      head :unauthorized
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
    if logged_in?
      uri = URI("http://85.143.176.51")
      uri.port = 9999
      http = Net::HTTP.new(uri.host, uri.port)
      req = Net::HTTP::Get.new("/?image_url=#{params[:user][:photo]}")
      resp = http.request(req)
        
      user = current_user
      user = user.attributes.slice("id", "fullname", "email", "waist", "hips", "chest")
      response_body_sizing = JSON.parse(resp.body)
      user["hips"] = response_body_sizing["hips"]
      user["waist"] = response_body_sizing["waists"]
      user["chest"] = response_body_sizing["breasts"]
      render json: {:user => user}
      
    else 
      head :unauthorized
    end
  end

  private

    def user_params
      params.require(:user).permit(:fullname, :email, :password, 
      :password_confirmation, 
      :waist, :hips, :chest)
    end
  
end
