class RankType < ActiveRecord::Base

  def self.select_list
    select_list_array = []
    all.order(:name).each do |rank_type|
      select_list_array << [rank_type.name, rank_type.id]
    end
    select_list_array
  end 

end
