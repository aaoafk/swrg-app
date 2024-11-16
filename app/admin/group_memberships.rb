ActiveAdmin.register GroupMembership do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :user_id, :group_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:user_id, :group_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  permit_params :user_id, :group_id

  index do
    selectable_column
    id_column
    column :user
    column :group
    column :created_at
    actions
  end

  filter :user
  filter :group
  filter :created_at
end
