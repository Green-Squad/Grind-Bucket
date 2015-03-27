require 'rails_helper'

describe HomeController, type: :controller do

  describe 'GET #index' do

    subject { get :index, {}, { fingerprint: '123456'} }

    it 'should render template' do
      expect(subject).to render_template('home/index')
    end

    it 'should have http status success' do
      expect(subject).to have_http_status(:success)
    end
  end

end
