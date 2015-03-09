rank_types = ['Prestige', 'Level', 'Total Points', 'Rank', 'Extra Levels']

rank_types.each do |rank_type|
  RankType.create(name: rank_type)
end

themes = [{name: 'default', primary_color: '#2b2f3e', secondary_color: '#ff404b', panel_text_color: '#8e909a', nav_link_color: '#7a7e8a', nav_link_hover_color: '#fff'},
          {name: 'purple-yellow', primary_color: '#3E2C42', secondary_color: '#ECBA52', panel_text_color: '#8e909a', nav_link_color: '#7a7e8a', nav_link_hover_color: '#fff'},
          {name: 'darkpink-yellow', primary_color: '#BB3C4F', secondary_color: '#ECBA52', panel_text_color: '#efefef', nav_link_color: '#efefef', nav_link_hover_color: '#fff'}]

themes.each do |theme|
  Theme.create(theme)
end