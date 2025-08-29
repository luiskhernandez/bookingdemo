class ProfileSessionsController < ApplicationController
  before_action :authenticate_user!

  def update
    case params[:as]
    when 'tutor'
      if current_user.tutor.present?
        session[:acting_as] = 'tutor'
        redirect_to tutor_dashboard_path, notice: 'Switched to Tutor mode'
      else
        redirect_to new_onboarding_tutor_path, notice: 'Please complete your tutor profile first'
      end
    when 'student'
      if current_user.student.present?
        session[:acting_as] = 'student'
        redirect_to student_dashboard_path, notice: 'Switched to Student mode'
      else
        redirect_to new_onboarding_student_path, notice: 'Please complete your student profile first'
      end
    when 'none'
      session.delete(:acting_as)
      redirect_to root_path, notice: 'Switched to general mode'
    else
      redirect_to root_path, alert: 'Invalid profile selection'
    end
  end

  private

  def auto_select_context
    return if session[:acting_as].present?

    if current_user.tutor.present? && current_user.student.blank?
      session[:acting_as] = 'tutor'
    elsif current_user.student.present? && current_user.tutor.blank?
      session[:acting_as] = 'student'
    end
  end
end
