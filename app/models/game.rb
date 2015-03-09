class Game < ActiveRecord::Base
  extend FriendlyId
  require 'open-uri'
  belongs_to :theme

  validates :name, presence: true
  before_create :set_theme
  after_create :fix_slug

  paginates_per 25
  friendly_id :slug_candidates, use: [:slugged, :finders]
  mount_uploader :image, GameImageUploader
  
  def approve
    self.status = 'Approved'
    save
  end
  
  def reject
    self.status = 'Rejected'
    save
  end

  def slug_candidates
    [
      :name,
      [:name, :id]
    ]
  end
  
  def self.getJSON
    game_platforms = [ 'ps4', 'xboxone', 'ps3', 'xbox360', 'pc', 'wii-u' ]
    
    headers =  {'X-Mashape-Key' => ENV['X_MASHAPE_KEY']}
    base_url = 'https://byroredux-metacritic.p.mashape.com/'
    
    games_hash = {}
    game_platforms.each do |platform|
      games_hash["#{platform}"] = JSON.load(open("#{base_url}game-list/#{platform}/new-releases", headers))
    end
    
    games_hash
  end
  
  def self.import
    games_hash = self.getJSON
    games_added = []
    games_hash.each do |platform, games|
      games['results'].each do |game|
        unless Game.where(name: game['name']).first
          games_added << Game.create(name: game['name'])
        end
      end
    end
    games_added
  end
  
  def self.select_list
    approved_games = Game.where(status: "Approved").order(:name)
    select_list_array = approved_games.map do |game|
      [game.name, game.id]
    end
    select_list_array.unshift([-1])
  end
  
  private

  def set_theme
    self.theme_id = Theme.where(name: 'default').first.id unless theme_id
  end
  
  def fix_slug
    self.slug = nil
    self.save!
  end
  
end
