class ApplicationController < ActionController::Base
  include Pundit::Authorization

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :redirect_if_onboarding_incomplete, unless: :devise_controller?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  protected

  def redirect_if_onboarding_incomplete
    return unless user_signed_in?
    return if onboarding_controller? || home_controller?
    
    # If user has no profiles and tries to access protected pages, redirect to home
    if current_user.tutor.blank? && current_user.student.blank?
      redirect_to root_path, notice: "Please complete your profile setup to continue."
    end
  end

  def onboarding_controller?
    controller_name.include?('onboarding') || 
    params[:controller]&.start_with?('onboarding/')
  end

  def home_controller?
    params[:controller] == 'home'
  end

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:timezone])
    devise_parameter_sanitizer.permit(:account_update, keys: [:timezone])
  end

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end
end
