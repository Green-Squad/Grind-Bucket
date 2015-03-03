require 'rails_helper'
require 'open-uri'

describe User, type: :model do
  describe '.create_username' do
    
    it 'should create a username' do
      user = User.create
      expect(user.username).to_not eq('')
    end
    
  end
  
  describe '.assign_color' do
    
    it 'should assign a color to a user' do
      user = User.create
      expect(user.color).to match(/^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$/)
    end
    
  end  
end
