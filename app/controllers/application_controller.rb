class ApplicationController < ActionController::Base
  require 'open-uri'
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :validate_user, except: :loading

  private
  
  def validate_user
    ip_address = request.remote_ip
    fingerprint = cookies[:fingerprint] 
    
    
    if fingerprint
      # Most recent identifier record that matches given IP Address and Fingerprint
      identifier = Identifier.where(ip_address: ip_address, fingerprint: fingerprint).order(created_at: :desc).first
      if identifier
        sign_in(User.find(identifier.user_id))
      elsif current_user  
        Identifier.where(ip_address: ip_address, fingerprint: fingerprint, user_id: current_user.id).first_or_create
      else
        user = User.create!
        Identifier.create(ip_address: ip_address, fingerprint: fingerprint, user_id: user.id)
        sign_in(user)     
      end
    else
      session[:intended_url] =  request.original_url
      redirect_to loading_url  
    end
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
      redirect_to :back || root_url 
    end
  end

end
