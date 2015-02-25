require 'rails_helper'

describe FingerprintController, type: :controller do

  describe 'POST #create' do
    
    it 'should set fingerprint in the session' do
      fingerprint = '123456'
      post :create, fingerprint: fingerprint, format: :json
      expect(session[:fingerprint]).to eq(fingerprint)
    end
    
    it 'should render json' do
      fingerprint = '123456'
      post :create, fingerprint: fingerprint, format: :json
      expect(response['Content-Type']).to include('application/json')
    end
    
    it 'should return success' do
      fingerprint = '123456'
      post :create, fingerprint: fingerprint, format: :json
      expect(response).to have_http_status(:success)
    end
    
    it 'should throw error if no fingerprint' do
      post :create, fingerprint: '', format: :json
      expect(response).to have_http_status(:unprocessable_entity)
    end

  end

end
