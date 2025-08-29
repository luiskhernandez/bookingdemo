class Tutors::DashboardController < ApplicationController
  before_action :ensure_tutor_profile

  def show
    @tutor = current_user.tutor
    authorize @tutor, :dashboard?
  end

  private

  def ensure_tutor_profile
    unless current_user.tutor.present?
      flash[:alert] = "You need to create a tutor profile first."
      redirect_to new_onboarding_tutor_path
    end
  end
end
