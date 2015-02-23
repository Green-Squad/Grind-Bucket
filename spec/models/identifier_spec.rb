require 'rails_helper'

describe Identifier, type: :model do
  describe '.create' do
    
    before(:each) do
      @ip_address = '192.168.0.1'
      @fingerprint = '29752308523'
      @user = FactoryGirl.create(:user)
    end
    
    context 'Successful creation' do
      it 'with a user_id, ip_address, and fingerprint' do
        expect{Identifier.create(ip_address: @ip_address, fingerprint: @fingerprint, user_id: @user.id)}.to change{Identifier.count}.by(1)
      end
    end
    
    context 'Unsuccessful creation' do
      it 'without anything' do
        expect{Identifier.create}.to_not change{Identifier.count}
      end
      
      it 'without ip_address' do
        expect{Identifier.create(ip_address: '', fingerprint: @fingerprint, user_id: @user.id)}.to_not change{Identifier.count}
      end
      
      it 'without fingerprint' do
        expect{Identifier.create(ip_address: @ip_address, fingerprint: '', user_id: @user.id)}.to_not change{Identifier.count}
      end
      
      it 'without user_id' do
        expect{Identifier.create(ip_address: @ip_address, fingerprint: @fingerprint, user_id: '')}.to_not change{Identifier.count}
      end
    end
  end

end