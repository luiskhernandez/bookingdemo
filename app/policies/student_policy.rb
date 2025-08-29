# frozen_string_literal: true

class StudentPolicy < ApplicationPolicy
  def show?
    user_owns_record?
  end

  def create?
    return false unless user.present?
    
    # Check directly in database for existing student
    !Student.exists?(user: user)
  end

  def update?
    user_owns_record?
  end

  def destroy?
    user_owns_record?
  end

  def dashboard?
    user_owns_record?
  end

  private

  def user_owns_record?
    user.present? && user.student == record
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.present?
        scope.where(user: user)
      else
        scope.none
      end
    end
  end
end