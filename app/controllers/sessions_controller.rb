# app/controllers/sessions_controller.rb
class SessionsController < ApplicationController
  allow_unauthenticated_access only: [ :new, :create, :validate, :verify ]

  def new
    redirect_to app_root_path if authenticated?
  end

  # app/controllers/sessions_controller.rb
  def create
    email = session[:email] || params[:email]
  
    if valid_email?(email)
      session[:email] = email  # Store email if not already stored
      otp = generate_otp
      store_otp_for_email(email, otp)
      UserMailer.otp_email(email, otp).deliver_later
    
      redirect_to validate_session_path
    else
      flash.now[:error] = "Please enter a valid email address"
      render :new
    end
  end

  def validate
    redirect_to new_session_path unless session[:email]
  end

  def verify
    email = session[:email]
    submitted_code = params[:code]

    if valid_otp?(email, submitted_code)
      user = User.find_or_create_by(email: email) do |u|
        u.role = :reader
        u.first_name = email.split("@").first
        u.last_name = "Unknown"
      end

      sign_in(user)
      session.delete(:email)
      redirect_to after_authentication_url
    else
      flash.now[:error] = "Invalid code"
      render :validate
    end
  end

  def destroy
    if current_user
      current_user.sessions.destroy_all # Clean up all sessions
      cookies.delete(:session_token) # Don't forget to clear the session cookie
      Current.reset # Reset Current attributes
    end
    redirect_to root_path, notice: "You have been signed out"
  end

  private

  def generate_otp
    SecureRandom.random_number(100000..999999).to_s
  end

  def valid_email?(email)
    URI::MailTo::EMAIL_REGEXP.match?(email)
  end

  def store_otp_for_email(email, otp)
    # Expire any existing OTP codes for this email
    OtpCode.where(email: email).destroy_all

    # Create new OTP code that expires in 10 minutes
    OtpCode.create!(
      email: email,
      code: otp,
      expires_at: 10.minutes.from_now
    )
  end

  def valid_otp?(email, submitted_code)
    otp_record = OtpCode.find_by(email: email)

    return false unless otp_record
    return false if otp_record.expires_at < Time.current

    # Validate the code
    is_valid = otp_record.code == submitted_code

    # Delete the OTP after validation attempt (one-time use)
    otp_record.destroy

    is_valid
  end
end
