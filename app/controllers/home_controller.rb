class HomeController < ApplicationController
  skip_before_action :validate_user, only: :loading
  def index
    
  end
  
  def loading
    
  end
end