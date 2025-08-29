# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  skip_before_action :authenticate_user!
  
  # GET /users/sign_up
  def new
    # Store the role from URL parameter in session for after signup
    if params[:role].present? && ['tutor', 'student'].include?(params[:role])
      session[:selected_role] = params[:role]
    end
    
    super
  end

  # POST /users
  def create
    super
  end

  protected

  # The path used after sign up.
  def after_sign_up_path_for(resource)
    # Check if user has a role selected and force profile completion
    selected_role = session[:selected_role]
    
    if selected_role == 'tutor' && resource.tutor.blank?
      session.delete(:selected_role) # Clear the role from session
      new_onboarding_tutor_path
    elsif selected_role == 'student' && resource.student.blank?
      session.delete(:selected_role) # Clear the role from session
      new_onboarding_student_path
    else
      # If no role selected or profile already exists, go to home page
      session.delete(:selected_role)
      root_path
    end
  end

  # The path used after sign up for inactive accounts.
  def after_inactive_sign_up_path_for(resource)
    # Always redirect to home for inactive accounts
    session.delete(:selected_role)
    root_path
  end

  private

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation, :timezone)
  end

  def account_update_params
    params.require(:user).permit(:email, :password, :password_confirmation, :current_password, :timezone)
  end
end