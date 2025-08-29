class Onboarding::TutorsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_no_tutor_profile

  def new
    @tutor = current_user.build_tutor
    authorize @tutor, :create?
  end

  def create
    @tutor = current_user.build_tutor(tutor_params)
    authorize @tutor, :create?
    
    ActiveRecord::Base.transaction do
      @tutor.save!
      create_default_lesson_type!
      session[:acting_as] = 'tutor'
    end

    redirect_to tutor_dashboard_path, notice: 'Tutor profile created successfully!'
  rescue ActiveRecord::RecordInvalid
    render :new, status: :unprocessable_entity
  end

  private

  def tutor_params
    params.require(:tutor).permit(:display_name, :bio, :timezone)
  end

  def ensure_no_tutor_profile
    return unless current_user.tutor.present?
    
    redirect_to tutor_dashboard_path, notice: 'You already have a tutor profile'
  end

  def create_default_lesson_type!
    lesson_type = @tutor.lesson_types.create!(
      title: "Standard Class",
      duration_minutes: 60,
      active: true
    )
    @tutor.update!(default_lesson_type: lesson_type)
  end
end
