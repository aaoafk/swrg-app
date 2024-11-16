# class App::Onboarding::StepsController < App::Onboarding::BaseController
#   SAFE_PATHS = %w(complete_profile select_group)
#   def show
#     redirect_to complete_profile_app_onboarding_steps_path
#   end

#   def complete_profile
#   end

#   def select_group
#     logger.debug "Current step: #{params[:current_step]}"
#     if current_user.update(user_params)
#       next_step = case params[:current_step]
#                   when 'complete_profile'
#                     select_group_app_onboarding_steps_path
#                   when 'select_group'
#                     logger.debug "Inside `select_group`"
#                     if create_group_membership
#                       complete_onboarding
#                       app_root_url
#                     else
#                       select_group_app_onboarding_steps_path
#                     end
#                   end
#       logger.debug "Next step is set to: #{next_step}"
#       redirect_to next_step
#     else
#       flash.now[:error] = current_user.errors.full_messages.to_sentence
#       render params[:current_step] if SAFE_PATHS.include?(params[:current_step])
#     end
#   end

#   def update
#     logger.debug "Current step: #{params[:current_step]}"
#     if current_user.update(user_params)
#       next_step = case params[:current_step]
#                   when 'complete_profile'
#                     select_group_app_onboarding_steps_path
#                   when 'select_group'
#                     logger.debug "Inside `select_group`"
#                     if create_group_membership
#                       complete_onboarding
#                       app_root_url
#                     else
#                       select_group_app_onboarding_steps_path
#                     end
#                   end
#       logger.debug "Next step is set to: #{next_step}"
#       redirect_to next_step
#     else
#       flash.now[:error] = current_user.errors.full_messages.to_sentence
#       render params[:current_step] if SAFE_PATHS.include?(params[:current_step])
#     end
#   end

#   def skip
#     current_user.update!(onboarded: true)
#     redirect_to app_root_path, notice: "You can always update your preferences later"
#   end

#   private

#   def user_params
#     case params[:current_step]
#     when 'complete_profile'
#       params.require(:user).permit(:first_name, :last_name)
#     when 'select_group'
#       params.permit(:group_id)
#     end
#   end

#   def create_group_membership(**args)
#     return false unless params[:group_id].present?

#     membership = GroupMembership.new(
#       user: current_user,
#       group_id: params[:group_id]
#     )

#     if membership.save
#       true
#     else
#       flash[:error] = membership.errors.full_messages.to_sentence
#       false
#     end
#   end

#   def complete_onboarding
#     current_user.update!(onboarded: true)
#   end
# end

class App::Onboarding::StepsController < App::Onboarding::BaseController
  require "ostruct"
  SAFE_PATHS = %w[complete_profile select_group].freeze

  def show
    redirect_to complete_profile_app_onboarding_steps_path
  end

  def complete_profile
  end

  def select_group
  end

  def update
    logger.debug "Current step: #{params[:current_step]}"
    result = process_step(params[:current_step])

    if result.success?
      redirect_to result.next_path
    else
      flash.now[:error] = result.error
      render params[:current_step] if SAFE_PATHS.include?(params[:current_step])
    end
  end

  def skip
    current_user.update!(onboarded: true)
    redirect_to app_root_path, notice: "You can always update your preferences later"
  end

  private

  def process_step(step)
    case step
    when "complete_profile"
      process_profile_update
    when "select_group"
      process_group_selection
    else
      OpenStruct.new(success?: false, error: "Invalid step")
    end
  end

  def process_profile_update
    if current_user.update(profile_params)
      OpenStruct.new(
        success?: true,
        next_path: select_group_app_onboarding_steps_path
      )
    else
      OpenStruct.new(
        success?: false,
        error: current_user.errors.full_messages.to_sentence
      )
    end
  end

  def process_group_selection
    return OpenStruct.new(
      success?: false,
      error: "No group selected"
    ) unless params[:group_id].present?

    membership = GroupMembership.new(
      user: current_user,
      group_id: params[:group_id]
    )

    if membership.save
      complete_onboarding
      OpenStruct.new(success?: true, next_path: app_root_url)
    else
      OpenStruct.new(
        success?: false,
        error: membership.errors.full_messages.to_sentence
      )
    end
  end

  def profile_params
    params.require(:user).permit(:first_name, :last_name)
  end

  def complete_onboarding
    current_user.update!(onboarded: true)
  end
end
