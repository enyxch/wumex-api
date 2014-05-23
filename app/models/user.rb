class User < ActiveRecord::Base
  before_create :set_auth_token
  validates :email, uniqueness: true, presence: true

  class << self
    def create_user(params)
      User.create({
        :password => params[:password],
        :email => params[:email],
        :user_name => params[:user_name],
        :first_name => params[:first_name],
        :last_name => params[:last_name]
        })
    end
  end

  private
    def set_auth_token
      return if authentication_token.present?

      begin
        self.authentication_token = SecureRandom.hex
      end while self.class.exists?(authentication_token: self.authentication_token)
    end
end
