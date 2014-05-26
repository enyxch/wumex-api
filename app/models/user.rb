class User < ActiveRecord::Base

  has_and_belongs_to_many :projects

  validates :email, uniqueness: true, presence: true

  devise :database_authenticatable, :token_authenticatable

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

end
