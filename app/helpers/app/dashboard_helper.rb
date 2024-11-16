# app/helpers/app/dashboard_helper.rb
module App::DashboardHelper
  def format_meeting_date(date)
    date.strftime("%B %d, %Y")
  end

  def format_meeting_time(date)
    date.strftime("%I:%M %p")
  end

  def next_meeting_for_user(user)
    user.groups
        .map(&:upcoming_meetings)
        .flatten
        .min_by(&:date)
  end
end
