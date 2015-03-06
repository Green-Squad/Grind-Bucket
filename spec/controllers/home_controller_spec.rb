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
  
  describe 'GET #loading' do
    
    render_views
    
    it 'should link to intended url' do
      session[:intended_url] = games_index_url
      get :loading
      expect(response.body).to include(games_index_url)
    end
    
    it 'should link to root url' do
      get :loading
      expect(response.body).to include(root_url)
    end
    
  end

end
