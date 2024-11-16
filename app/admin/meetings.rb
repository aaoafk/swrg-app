ActiveAdmin.register Meeting do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :date, :group_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:date, :group_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  permit_params :date, :group_id, location_attributes: [ :id, :address ]

  index do
    selectable_column
    id_column
    column :group
    column :date
    column "Location" do |meeting|
      meeting.location&.address
    end
    actions
  end

  form do |f|
    f.inputs do
      f.input :group
      f.input :date
      f.has_many :location, allow_destroy: true do |l|
        l.input :address
      end
    end
    f.actions
  end

  filter :group
  filter :date
end
