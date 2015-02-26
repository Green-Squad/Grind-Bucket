class VotesController < ApplicationController
  def create
    params[:vote][:user_id] = current_user ? current_user.id : nil
    vote = Vote.new(vote_params)

    existing_vote = Vote.where(user_id: vote.user_id, max_rank_id: vote.max_rank_id).first
    if existing_vote
      if vote.vote == existing_vote.vote
        existing_vote.destroy
        json = {}
        status = 204
      else
        existing_vote.vote = vote.vote
        existing_vote.save
        json = existing_vote.to_json
        status = 200
      end
    else
      if vote.save
        json = vote.to_json
        status = 201
      else
        json = {}
        status = 422
      end
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