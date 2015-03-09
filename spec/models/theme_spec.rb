require 'rails_helper'

RSpec.describe Theme, type: :model do

  before(:each) do
    Theme.delete_all
  end

  describe '#generate' do
    it 'creates a file' do
      theme = FactoryGirl.create(:theme)
      expect(File).to receive(:open).with(Rails.root.join('app', 'assets', 'stylesheets', 'required', 'themes', "#{theme.name}.scss"), "w")
      theme.generate
    end
  end

  describe '.generate_all' do
    it 'creates 10 files' do
      10.times do
        FactoryGirl.create(:theme)
      end

      expect(File).to receive(:open).exactly(10).times
      Theme.generate_all
    end
  end
end
