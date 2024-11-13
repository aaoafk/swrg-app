class App::Onboarding::StepsController < App::Onboarding::BaseController
  def show
    redirect_to complete_profile_app_onboarding_steps_path
  end

  def complete_profile
  end

  def select_group
  end

  def update
    if current_user.update(user_params)
      next_step = case params[:current_step]
                  when 'complete_profile'
                    select_group_app_onboarding_steps_path
                  when 'select_group'
                    complete_onboarding
                    app_root_path
                  end
          
      redirect_to next_step
    else
      render params[:current_step]
    end
  end

  def skip
    current_user.update!(onboarded: true)
    redirect_to app_root_path, notice: "You can always update your preferences later"
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name)
  end

  def complete_onboarding
    current_user.update!(onboarded: true)
  end
end
