# app/admin/dashboard.rb
ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    columns do
      column do
        panel "Recent Groups" do
          table_for Group.order(created_at: :desc).limit(5) do
            column :name
            column :group_type
            column "Members" do |group|
              group.users.count
            end
            column "Actions" do |group|
              span link_to("View", admin_group_path(group))
            end
          end
        end

        panel "Upcoming Meetings" do
          table_for Meeting.where("date > ?", Time.current).order(date: :asc).limit(5) do
            column "Group" do |meeting|
              link_to meeting.group.name, admin_group_path(meeting.group)
            end
            column :date
            column "Location" do |meeting|
              meeting.location&.address
            end
          end
        end
      end

      column do
        panel "Statistics" do
          div do
            ul do
              li "Total Users: #{User.count}"
              li "Total Groups: #{Group.count}"
              li "Upcoming Meetings: #{Meeting.where("date > ?", Time.current).count}"
              li "Active Reading Groups: #{Group.reading_group.count}"
            end
          end
        end

        panel "Recent Users" do
          table_for User.order(created_at: :desc).limit(5) do
            column :email
            column "Name" do |user|
              "#{user.first_name} #{user.last_name}"
            end
            column :role
            column "Groups" do |user|
              user.groups.count
            end
          end
        end
      end
    end
  end
end
