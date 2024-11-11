# app/controllers/sessions_controller.rb
class SessionsController < ApplicationController
  def new
  end

  def create
    email = params[:email]
    if valid_email?(email)
      otp = generate_otp
      store_otp_for_email(email, otp)
      
      # Send email with OTP
      UserMailer.otp_email(email, otp).deliver_later
      
      session[:email] = email
      redirect_to validate_session_path
    else
      flash.now[:error] = "Please enter a valid email address"
      render :new
    end
  end

  def validate
  end

  def verify
    email = session[:email]
    submitted_code = params[:code]
    
    if valid_otp?(email, submitted_code)
      user = User.find_or_create_by(email: email)
      sign_in(user)
      redirect_to app_path
    else
      flash.now[:error] = "Invalid code"
      render :validate
    end
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
