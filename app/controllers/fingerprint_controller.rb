class FingerprintController < ApplicationController
  skip_before_action :validate_user
  skip_before_action :verify_authenticity_token
  def create
    if params[:fingerprint] && !params[:fingerprint].blank?
      fingerprint = params[:fingerprint]
      session[:fingerprint] = fingerprint
      json = { fingerprint: fingerprint }
      status = :success
    else
      json = {}
      status = :unprocessable_entity
    end

    respond_to do |format|
      format.json { render json:  json, status: status}
    end
  end

end