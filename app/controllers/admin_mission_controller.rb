class AdminMissionController < ActionController::Base
  allow_browser versions: :modern

  http_basic_authenticate_with(
    name: Rails.application.credentials.dig(:mission_control, :user_name),
    password: Rails.application.credentials.dig(:mission_control, :password)
  )
end
