class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_sites
  
  include Pagy::Backend  
  
  def set_sites
    @all_sites = Site.all
    @all_site_count = Site.all.count
  end
  
  private
  
  def after_sign_in_path_for(resource_or_scope)
      if resource_or_scope.is_a?(Admin)
        admin_top_path
      else
        my_page_path
      end
  end

  def after_sign_out_path_for(resource_or_scope)
      if resource_or_scope == :user
        root_path
      elsif resource_or_scope == :admin
        new_admin_session_path
      else
        root_path
      end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:nick_name, :email, :password, :encrypted_password])
  end
end
