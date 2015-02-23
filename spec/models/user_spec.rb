require 'rails_helper'
require 'open-uri'

describe User, type: :model do
  describe '.asdfa' do
    
    it 'should create a username' do
      user = User.create
      expect(user.username).to_not eq('')
    end
    
  end  
end
