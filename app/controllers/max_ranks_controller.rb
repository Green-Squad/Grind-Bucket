class MaxRanksController < ApplicationController
  before_action :validate_recaptcha, only: :create
  def create
    @max_rank = MaxRank.new(max_rank_params)
    if @max_rank.save
      flash[:success] = "Successfully created #{@max_rank.rank_type.name} for #{@max_rank.game.name}."
    else
      flash[:error] = 'Error creating a max rank.'
    end
    redirect_to :back || root_url
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def max_rank_params
    params.require(:max_rank).permit(:rank_type_id, :value, :source, :game_id)
  end
end
