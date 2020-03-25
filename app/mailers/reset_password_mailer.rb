class ResetPasswordMailer < ApplicationMailer

    def reset(user, token)
        @token = token
        mail(from: 'devopsd@yandex.ru', to: user.email, subject: 'Сброс пароля')
    end
end 