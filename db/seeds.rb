
rank_types = ['Prestige', 'Level', 'Total Points', 'Rank', 'Extra Levels']

rank_types.each do |rank_type|
  RankType.create(name: rank_type)
end
