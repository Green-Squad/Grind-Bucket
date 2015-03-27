class FingerprintController < ApplicationController
  skip_before_action :validate_user
  skip_before_action :verify_authenticity_token

  def lookupUser
    if params[:fingerprint] && params[:fingerprint].present?
      fingerprint = params[:fingerprint]
      session[:fingerprint] = fingerprint
      ip_address = request.remote_ip
      identifier = Identifier.where(ip_address: ip_address, fingerprint: fingerprint).order(created_at: :desc).first
      if identifier
        user = User.find(identifier.user_id)
      else
        user = User.create!
        Identifier.create(ip_address: ip_address, fingerprint: fingerprint, user_id: user.id)
      end
      json = user.to_json
      status = 200
      login_and_remember(user)
    else
      json = {}
      status = 422
    end

    respond_to do |format|
      format.json { render json: json, status: status }
    end
  end

  def update
    if params[:fingerprint] && params[:fingerprint].present?
      fingerprint = params[:fingerprint]
      session[:fingerprint] = fingerprint
      ip_address = request.remote_ip
      if current_user
        identifier = Identifier.where(ip_address: ip_address, fingerprint: fingerprint, user_id: current_user.id).first_or_create
        json = identifier.to_json
        status = 201
        cookies[:new_session] = false
      else
        json = {}
        status = 422
      end
    else
      json = {}
      status = 422
    end

    respond_to do |format|
      format.json { render json: json, status: status }
    end
  end

end