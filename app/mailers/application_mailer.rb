# app/mailers/application_mailer.rb
class ApplicationMailer < ActionMailer::Base
  default from: "swrg-app@gmail.com"
  layout "mailer"

  # This will retry failed emails up to 3 times
  around_deliver do |mailer, deliver|
    retries = 0
    begin
      deliver.call
    rescue => error
      if (retries += 1) <= 3
        Rails.logger.warn "Retrying email delivery. Attempt #{retries} of 3"
        sleep(2 ** retries) # exponential backoff
        retry
      else
        raise error
      end
    end
  end
end
