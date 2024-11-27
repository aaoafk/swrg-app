# app/controllers/concerns/authentication.rb
module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :require_authentication
    helper_method :authenticated?, :current_user
  end

  class_methods do
    def allow_unauthenticated_access(**options)
      skip_before_action :require_authentication, **options
    end
  end

  private
  def authenticated?
    current_user.present?
  end

  def authenticate_admin_user!
    unless current_user&.admin?
      flash[:alert] = "You are not authorized to access this area"
      redirect_to root_path
    end
  end

  def current_user
    Current.user if resume_session
  end

  def require_authentication
    resume_session || request_authentication
  end

  def resume_session
    if session = find_session_by_cookie
      set_current_session(session)
      true
    end
  end

  def find_session_by_cookie
    if token = cookies.signed[:session_token]
      Session.find_by(token: token)
    end
  end

  def request_authentication
    session[:return_to_after_authenticating] = if current_user&.onboarded?
                                                 request.url
    else
                                                 app_onboarding_root_path
    end

    redirect_to new_session_path
  end

  # TODO: session.delete(:return_to_after_authenticating) is null at this point
  def after_authentication_url
    session.delete(:return_to_after_authenticating) || app_onboarding_root_path || app_root_path
  end

  def sign_in(user)
    start_new_session_for(user)
  end

  def start_new_session_for(user)
    user.sessions.create!(
      user_agent: request.user_agent,
      ip_address: request.remote_ip
    ).tap do |session|
      set_current_session(session)
    end
  end

  def set_current_session(session)
    Current.session = session
    Current.user = session.user
    cookies.signed.permanent[:session_token] = {
      value: session.token,
      httponly: true,
      same_site: :lax
    }
  end

  def sign_out
    terminate_session
  end

  def terminate_session
    Current.session&.destroy
    cookies.delete(:session_token)
    Current.reset
  end
end
