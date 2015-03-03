class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable

  before_create :create_username
  before_create :assign_color

  private
  def create_username
    adjective = RandomUsername.adjective
    noun = RandomUsername.noun
    number = SecureRandom.random_number(9000) + 1000
    self.username = "#{adjective} #{noun} #{number}"
    create_username if User.where(username: username).count > 0
  end
  
  def assign_color
    color_array = ['#fa8072', '#fa8072', '#faad72', '#fada72', '#ecfa72', 
      '#87ceeb', '#87aceb', '#878beb', '#a487eb', '#98fb98', '#98fbb9', 
      '#98fbd9', '#98fbfb', '#dda0dd', '#dda0c8', '#dda0b4', '#dda0a0']
    
    array_size = color_array.count
    index = SecureRandom.random_number(array_size)
    self.color = color_array[index]
  end
end