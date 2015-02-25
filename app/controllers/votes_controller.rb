class VotesController < ApplicationController
  def create
    params[:vote][:user_id] = current_user ? current_user.id : nil
    vote = Vote.new(vote_params)
    if vote.save
      json = vote.to_json
      status = 200
    else
      json = {}
      status = 422
    end

    respond_to do |format|
      format.json { render json:  json, status: status}
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def vote_params
    params.require(:vote).permit(:vote, :max_rank_id, :user_id)
  end

end