# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  def show?
    user == record
  end

  def update?
    user == record
  end

  def destroy?
    user == record
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.present?
        scope.where(id: user.id)
      else
        scope.none
      end
    end
  end
end