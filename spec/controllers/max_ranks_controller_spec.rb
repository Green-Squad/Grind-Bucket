require 'rails_helper'

RSpec.describe MaxRanksController, type: :controller do
  describe 'POST #create' do
    
    before(:each) do
      request.env["HTTP_REFERER"] = root_url
    end
    
    context "successful max rank creation" do
      
      subject { post :create, max_rank: { rank_type_id: FactoryGirl.create(:rank_type).id, value: Faker::Number.number(10), source: Faker::Internet.url, game_id: FactoryGirl.create(:game).id  } }
      
      it "should create a max rank" do
        allow(controller).to receive(:validate_recaptcha)
        expect{ post :create, max_rank: { rank_type_id: FactoryGirl.create(:rank_type).id, value: Faker::Number.number(10), source: Faker::Internet.url, game_id: FactoryGirl.create(:game).id } }.to change{MaxRank.count}.by(1)
      end
      
      it "should redirect back" do
        allow(controller).to receive(:validate_recaptcha)
        expect(subject).to redirect_to(root_url)
      end
      
      it "should flash success" do
        allow(controller).to receive(:validate_recaptcha)
        subject
        expect(flash[:success]).to be_present
      end
    end
    context "unsuccessful max rank creation" do
      
      subject { post :create, max_rank: { rank_type_id: '', value: '', source: '', game_id: '' } }
      
      it "should not create a blank max rank" do
        allow(controller).to receive(:validate_recaptcha)
        expect{ post :create, max_rank: { rank_type_id: '', value: '', source: '', game_id: '' } }.to_not change{MaxRank.count}
      end
      it "should redirect back" do
        allow(controller).to receive(:validate_recaptcha)
        expect(subject).to redirect_to(root_url)
      end
      it "should flash error" do
        allow(controller).to receive(:validate_recaptcha)
        subject
        expect(flash[:error]).to be_present
      end
    end
  end
end
