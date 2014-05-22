class User < ActiveRecord::Base
  before_create :set_auth_token
  validates :email, uniqueness: true, presence: true

  private
    def set_auth_token
      return if authentication_token.present?

      begin
        self.authentication_token = SecureRandom.hex
      end while self.class.exists?(authentication_token: self.authentication_token)
    end
end
