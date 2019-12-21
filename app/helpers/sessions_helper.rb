module SessionsHelper

    def sign_in(user)
        auth_token = remember user
    end

    def current_user
        user = User.find_by(id: @user_id)
        if user && user.authenticated?(@remember_token)
            @current_user = user
        end
    end

    def logged_in?(user_id, auth_token)
        @user_id = user_id
        @remember_token = auth_token
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
end
