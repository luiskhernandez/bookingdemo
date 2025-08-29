class Onboarding::StudentsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_no_student_profile

  def new
    @student = current_user.build_student
  end

  def create
    @student = current_user.build_student(student_params)
    
    if @student.save
      session[:acting_as] = 'student'
      redirect_to student_dashboard_path, notice: 'Student profile created successfully!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def student_params
    params.require(:student).permit(:first_name, :last_name)
  end

  def ensure_no_student_profile
    return unless current_user.student.present?
    
    redirect_to student_dashboard_path, notice: 'You already have a student profile'
  end
end
