class FingerprintController < ApplicationController
  skip_before_action :validate_user
  skip_before_action :verify_authenticity_token
  def create
    if params[:fingerprint] && params[:fingerprint].present?
      fingerprint = params[:fingerprint]
      session[:fingerprint] = fingerprint
      json = { fingerprint: fingerprint }
      status = 200
    else
      json = {}
      status = 422
    end

    respond_to do |format|
      format.json { render json:  json, status: status}
    end
  end

end