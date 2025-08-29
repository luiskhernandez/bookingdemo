# frozen_string_literal: true

class LessonTypePolicy < ApplicationPolicy
  def show?
    # LessonTypes can be viewed publicly or by their owner
    true
  end

  def create?
    user_owns_tutor?
  end

  def update?
    user_owns_tutor?
  end

  def destroy?
    user_owns_tutor?
  end

  private

  def user_owns_tutor?
    user.present? && user.tutor == record.tutor
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.present? && user.tutor.present?
        scope.where(tutor: user.tutor)
      else
        scope.where(active: true) # Public can only see active lesson types
      end
    end
  end
end