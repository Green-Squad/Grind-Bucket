class ApplicationController < ActionController::Base
  require 'open-uri'
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :validate_user

  private
  
  def validate_user
    unless params[:cookies] && params[:cookies] == 'false'
      ip_address = request.remote_ip
      fingerprint = session[:fingerprint]
      if fingerprint
        # Most recent identifier record that matches given IP Address and Fingerprint
        identifier = Identifier.where(ip_address: ip_address, fingerprint: fingerprint).order(created_at: :desc).first
        if identifier
          user = User.find(identifier.user_id)
          unless user == current_user
            login_and_remember(user)
          end
        elsif current_user
          Identifier.where(ip_address: ip_address, fingerprint: fingerprint, user_id: current_user.id).first_or_create
        else
          user = User.create!
          Identifier.create(ip_address: ip_address, fingerprint: fingerprint, user_id: user.id)
          login_and_remember(user)
        end
      else
        session[:intended_url] = request.original_url
        redirect_to loading_url  
      end
    end
  end
  
  def login_and_remember(user)
    sign_in(user)
    user.remember_me!
    
    user_cookie = User.serialize_into_cookie(user)
    cookies.signed[:remember_user_token] = { 
      value: user_cookie, 
      expires: 2.weeks.from_now,
      httponly: true
    }
  end
  
  #-> Prelang (user_login:devise)
  def require_user_signed_in
    unless user_signed_in?

      # If the user came from a page, we can send them back.  Otherwise, send
      # them to the root path.
      if request.env['HTTP_REFERER']
        fallback_redirect = :back
      elsif defined?(root_path)
        fallback_redirect = root_path
      else
        fallback_redirect = "/"
      end

      redirect_to fallback_redirect, flash: {error: "You must be signed in to view this page."}
    end
  end
  
  def validate_recaptcha
    url = 'https://www.google.com/recaptcha/api/siteverify'
    response = params['g-recaptcha-response']
    secret = ENV['RECAPTCHA_SECRET_KEY']
    json_response = JSON.load(open("#{url}?secret=#{secret}&response=#{response}"))
    unless json_response['success']
      flash[:error] = 'Could not verify that you are human. Please try again.'
      redirect_back
    end
  end
  
  def redirect_back
    if request.env["HTTP_REFERER"]
      redirect_to :back
    else 
      redirect_to root_url 
    end
  end

end
