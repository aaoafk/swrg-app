# config/initializers/dartsass.rb
Rails.application.config.dartsass.builds = {
  "#{Rails.root}/vendor/assets/stylesheets/active_admin.scss" => "#{Rails.root}/vendor/assets/builds/active_admin.css"
}
