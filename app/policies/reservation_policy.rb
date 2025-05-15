class ReservationPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    user.librarian? || user == record.user
  end

  def create?
    user.librarian? || (user.member? && user.id == record.user_id)
  end

  def update?
    user.librarian?
  end

  def destroy?
    user.librarian? || user == record.user
  end

  class Scope < Scope
    def resolve
      if user.librarian?
        scope.all
      else
        scope.where(user_id: user.id)
      end
    end
  end
end
