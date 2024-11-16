ActiveAdmin.register Group do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :group_type, :max_size, :name
  #
  # or
  #
  # permit_params do
  #   permitted = [:group_type, :max_size, :name]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
 # app/admin/groups.rb
  permit_params :name, :group_type, :max_size

  index do
    selectable_column
    id_column
    column :name
    column :group_type
    column :max_size
    column "Members" do |group|
      group.users.count
    end
    column "Meetings" do |group|
      group.meetings.count
    end
    actions
  end

  filter :name
  filter :group_type
  filter :max_size
end
