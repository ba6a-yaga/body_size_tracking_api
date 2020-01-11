module SessionsHelper

    def sign_in(user)
        @auth_token = remember user
    end

    def current_user
        # TODO: Заменить на кеш хранилище
        user = User.find_by(id: @user_id)
        if user && user.authenticated?(@auth_token)
            @current_user = user
        end
    end

    def logged_in? 
        !current_user.nil?
    end

    def remember(user)
        user.remember
    end

    def forget(user) 
        user.forget
    end

    def logout
        forget(current_user)
        @current_user = nil
    end

    def check_header
        if !request.headers["X-BDS-M-AUTH-TOKEN"].nil?
          @auth_token ||= request.headers["X-BDS-M-AUTH-TOKEN"]
        end
    end

    def check_user_id
        @user_id ||= params[:id] ? params[:id] : request.headers["X-BDS-M-USER-ID"]
    end

    def add_headers
        response.set_header "X-BDS-M-AUTH-TOKEN", @auth_token
    end
end
