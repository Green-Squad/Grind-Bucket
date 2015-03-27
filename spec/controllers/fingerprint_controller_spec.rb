require 'rails_helper'

describe FingerprintController, type: :controller do

  describe 'post #lookupUser' do
    context 'successful lookup' do
      before(:each) do
        request.remote_addr = '127.0.0.1'
        @fingerprint = '123456'
      end

      subject { post :lookupUser, fingerprint: @fingerprint, format: :json }

      it 'should return a user if existing identifier for that fingerprint' do
        user = FactoryGirl.create(:user)
        Identifier.create(fingerprint: @fingerprint, ip_address: '127.0.0.1', user_id: user.id)

        subject

        response_json = JSON.parse(response.body, symbolize_names: true)
        user_json = JSON.parse(user.to_json, symbolize_names: true)
        expect(response_json).to eq(user_json)
      end

      it 'should create a user if no existing identifier for that fingerprint' do
        expect { subject }.to change { User.count }.by(1)
      end

      it 'should return a new user if no existing identifier for that fingerprint' do
        subject
        response_json = JSON.parse(response.body, symbolize_names: true)
        expect(User.find(response_json[:id])).to_not be(nil)
      end

      it 'should have status 200 OK' do
        subject
        expect(response).to have_http_status('200')
      end
    end
    context 'unsuccessful lookup' do
      it 'should throw error if no fingerprint' do
        post :lookupUser, fingerprint: '', format: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'post #update' do

    before(:each) do
      request.remote_addr = '127.0.0.1'
    end

    context 'successful update' do
      before(:each) do
        @fingerprint = '123456'
      end

      subject { post :update, fingerprint: @fingerprint, format: :json }

      context 'current user' do

        before(:each) do
          @user = FactoryGirl.create(:user)
          sign_in @user
          @identifier = Identifier.create(fingerprint: @fingerprint, ip_address: '127.0.0.1', user_id: @user.id)
        end

        it 'should return an identifier' do
          subject
          response_json = JSON.parse(response.body, symbolize_names: true)
          identifier_json = JSON.parse(@identifier.to_json, symbolize_names: true)
          expect(response_json).to eq(identifier_json)
        end

        it 'should have status 200 OK' do
          subject
          expect(response).to have_http_status('201')
        end
      end

    end

    context 'unsuccessful update' do
      it 'should throw error if no fingerprint' do
        post :update, fingerprint: '', format: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'should throw error if no current user' do
        post :update, fingerprint: '123456', format: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
