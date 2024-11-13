class App::Onboarding::BaseController < App::BaseController
  before_action :require_unboarded_user
  layout 'onboarding'

  private

  def require_unboarded_user
    redirect_to app_root_path if current_user.onboarded?
  end
end
