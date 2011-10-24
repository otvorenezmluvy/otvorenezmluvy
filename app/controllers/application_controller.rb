class ApplicationController < ActionController::Base
  extend ActiveSupport::Memoizable

  protect_from_forgery

  before_filter :check_ip_ban
  before_filter :authenticate
  before_filter :set_body_class
  before_filter :remember_current_path, :unless => :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    redirect_to root_url
  end

  protected
  def authenticate
    return unless Rails.env.production?
    authenticate_or_request_with_http_basic do |username, password|
      username == "tis" && password == "afp"
    end
  end

  def remember_current_path
    session[:return_to] = request.env['PATH_INFO']
  end

  def after_sign_in_path_for(resource)
    session[:return_to] || root_path
  end

  def check_ip_ban
    unless BannedIp.find_by_ip(request.remote_ip).nil?
      render :text => "Prístup na tieto stránky Vám bol zakázaný, kontaktujte TIS+AFP", :status => 403
    end
  end

  def documents_repository
    ::Configuration.documents_repository
  end

  def pages_repository
    ::Configuration.pages_repository
  end

  def factic
    ::Configuration.factic
  end

  # if user is logged in, return current_user, else return guest_user
  def current_or_guest_user
    if current_user
      if session[:guest_user_id]
        logging_in
        guest_user.destroy
        session[:guest_user_id] = nil
      end
      current_user
    else
      guest_user
    end
  end

  def guest_user
    u = User.find(session[:guest_user_id].nil? ? session[:guest_user_id] = create_guest_user.id : session[:guest_user_id])
    u.update_tracked_fields!(request)
    u
  end
  memoize :guest_user

  # called (once) when the user logs in, insert any code your application needs
  # to hand off from guest_user to current_user.
  def logging_in
    #TODO should we migrate all commentaries from quest user to logged in?
  end

  private

  def create_guest_user
    name = "#{Time.now.to_i}#{rand(99)}"
    u = User.create(:name => "guest_#{name}", :email => "guest_#{name}@email.com", :password => "CrowdCloudGuestUser123", :guest => true)
  end

  def set_body_class
    @body_class = "detail devise" if devise_controller?
  end
end
