class MaxRanksController < ApplicationController
  before_action :validate_recaptcha, only: :create
  before_action :set_max_rank, only: [:verify, :unverify]
  before_action :authenticate_admin_user!, only: [:verify, :unverify]
  def create
    params[:max_rank][:user_id] = current_user ? current_user.id : nil
    @max_rank = MaxRank.new(max_rank_params)
    if @max_rank.save
      flash[:success] = "Successfully created #{@max_rank.rank_type.name} for #{@max_rank.game.name}."
      Vote.create(max_rank_id: @max_rank.id, user_id: current_user.id, vote: 1)
    else
      flash[:error] = 'Error creating a max rank.'
    end
    redirect_back
  end

  def verify
    if @max_rank && @max_rank.verify
      flash[:success] = "Successfully verified Max Rank #{@max_rank.id}."
    else
      flash[:error] = "Max Rank #{params[:id]} could not be found."
    end
    redirect_back
  end

  def unverify
    if @max_rank && @max_rank.unverify
      flash[:success] = "Successfully unverified Max Rank #{@max_rank.id}."
    else
      flash[:error] = "Max Rank #{params[:id]} could not be found."
    end
    redirect_back
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def max_rank_params
    params.require(:max_rank).permit(:rank_type_id, :value, :source, :game_id, :user_id)
  end

  def set_max_rank
    @max_rank = MaxRank.find_by_id(params[:id])
  end
end
