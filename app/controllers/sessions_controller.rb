class SessionsController < ApplicationController
  after_action :add_headers, only: [:create]

  def create 
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      sign_in @user
      user = @user.attributes.slice("id", "fullname", "email", "waist", "hips", "chest",
        "height", "waist_to_top", "arms", "waist_to_bottom", "head")
      render json: {:user => user}
    else     
      if !@user 
        @user = User.new
        @user.errors.messages[:email] = "email not found"
      elsif !@user.authenticate(params[:session][:password]) 
        @user.errors.messages[:password] = "incorrect password"
      end

      render json: {:errors => @user.errors.messages}, status: :unprocessable_entity
    end
  end

  def destroy
    logout if logged_in?(params[:session][:user_id], params[:session][:auth_token])
    head :success
  end

  def reset
    # Поиск пользователя по почте
    if (user = User.find_by(email: params[:email]))
      # - Генерация кода
      # - Создания дайджест кода
      # - Сохранение дайджест в базе
      code = user.reset_password
      # - Отправка кода на почту
      
    end
  end


end
