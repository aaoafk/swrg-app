class AdminMissionController < ActionController::Base
  allow_browser versions: :modern

  if Rails.application.credentials.mission_control
    http_basic_authenticate_with(
      name: Rails.application.credentials.mission_control[:user_name],
      password: Rails.application.credentials.mission_control[:password]
    )
  else
    Rails.logger.info "mission_control credentials are not defined"
  end 
end
