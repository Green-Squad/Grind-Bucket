class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  #devise :database_authenticatable, :registerable#,
         #:recoverable, :rememberable, :trackable, :validatable

  before_create :create_username

  private
  def create_username
    adjective = RandomUsername.adjective
    noun = RandomUsername.noun
    number = SecureRandom.random_number(9000) + 1000
    self.username = "#{adjective} #{noun} #{number}"
    create_username if User.where(username: username).count > 0
  end
end

