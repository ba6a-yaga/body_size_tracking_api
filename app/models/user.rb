class User < ApplicationRecord
    attr_accessor :remember_token
    attr_accessor :reset_password_token
    attr_accessor :auth_token
    before_save { self.email = email.downcase }

    VALID_INTEGER_RANGE = /([1-9]|[1-9][0-9]|[1-2][0-9][0-9])/i
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
    validates :email, presence: true, length: { maximum: 255},
    uniqueness: { case_sensitive: false },
    :format => { with: VALID_EMAIL_REGEX}
    has_secure_password
    validates :password, length: { minimum: 6 }, allow_blank: true
    validates_inclusion_of :waist, :in => 10..300, :allow_blank => true
    validates_inclusion_of :hips, :in => 10..300, :allow_blank => true
    validates_inclusion_of :chest, :in => 10..300, :allow_blank => true
    # has_secure_token :auth_token

    # Возвращает дайджест для указанной строки. 
    def User.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? 
        BCrypt::Engine::MIN_COST :
        BCrypt::Engine.cost 

        BCrypt::Password.create(string, cost: cost)
    end

    
    def hex_email
        User.digest "#{self.email}#{self.id.to_s}"
    end
    
    # Возвращает случайный токен.
    def User.new_token
        SecureRandom.urlsafe_base64
    end

    # Запоминает пользователя в базе данных для использования в постоянных сеансах.
    def remember 
        self.remember_token = User.new_token
        if update_attribute(:remember_digest, User.digest(self.remember_token)) 
            self.remember_token
        end
    end

    # Возвращает true, если указанный токен соответствует дайджесту. 
    def authenticated?(remember_token)
        return false if remember_digest.nil?
        BCrypt::Password.new(remember_digest).is_password?(remember_token) 
    end

    # Забывть пользователя
    def forget 
        update_attribute(:remember_digest, nil)
    end

    # Генерация токена сброса пароля
    def reset_password
        self.reset_password_token = User.new_token
        if update_attribute(:reset_password_digest, User.digest(self.reset_password_token)) 
            self.reset_password_token
        end
    end
end
