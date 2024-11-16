ActiveAdmin.register User do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :first_name, :last_name, :role, :email, :onboarded
  #
  # or
  #
  # permit_params do
  #   permitted = [:first_name, :last_name, :role, :email, :onboarded]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  permit_params :email, :first_name, :last_name, :role, :onboarded

  index do
    selectable_column
    id_column
    column :email
    column :first_name
    column :last_name
    column :role
    column :onboarded
    column "Groups" do |user|
      user.groups.count
    end
    actions
  end

  filter :email
  filter :first_name
  filter :last_name
  filter :role
  filter :onboarded
end
