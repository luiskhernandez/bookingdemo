class Tutors::LessonTypesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_tutor_profile
  before_action :set_lesson_type, only: [:edit, :update, :destroy]

  def index
    @lesson_types = policy_scope(current_user.tutor.lesson_types)
  end

  def new
    @lesson_type = current_user.tutor.lesson_types.build
    authorize @lesson_type
  end

  def create
    @lesson_type = current_user.tutor.lesson_types.build(lesson_type_params)
    authorize @lesson_type

    if @lesson_type.save
      redirect_to tutor_dashboard_path, notice: 'Lesson type was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @lesson_type
  end

  def update
    authorize @lesson_type

    if @lesson_type.update(lesson_type_params)
      redirect_to tutor_dashboard_path, notice: 'Lesson type was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @lesson_type
    
    if @lesson_type == current_user.tutor.default_lesson_type
      redirect_to tutor_dashboard_path, alert: 'Cannot delete the default lesson type.'
    else
      @lesson_type.destroy
      redirect_to tutor_dashboard_path, notice: 'Lesson type was successfully deleted.'
    end
  end

  private

  def set_lesson_type
    @lesson_type = current_user.tutor.lesson_types.find(params[:id])
  end

  def lesson_type_params
    params.require(:lesson_type).permit(:title, :duration_minutes, :active)
  end

  def ensure_tutor_profile
    unless current_user.tutor.present?
      flash[:alert] = "You need to create a tutor profile first."
      redirect_to new_onboarding_tutor_path
    end
  end
end