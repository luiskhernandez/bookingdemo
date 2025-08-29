class Students::DashboardController < ApplicationController
  before_action :ensure_student_profile

  def show
    @student = current_user.student
    authorize @student, :dashboard?
  end

  private

  def ensure_student_profile
    unless current_user.student.present?
      flash[:alert] = "You need to create a student profile first."
      redirect_to new_onboarding_student_path
    end
  end
end
