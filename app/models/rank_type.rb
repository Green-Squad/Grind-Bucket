class RankType < ActiveRecord::Base
  
  def self.select_list
    select_list_array = []
    all.order(:name).each do |item|
      select_list_array << [item.name, item.id]
    end
    select_list_array
  end

end
