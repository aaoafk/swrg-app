# app/mailers/user_mailer.rb
class UserMailer < ApplicationMailer
  def otp_email(email, code)
    @code = code
    @email = email
    
    mail(
      to: email,
      subject: "Your Swarthmore Reading Group verification code"
    )
  end
end
