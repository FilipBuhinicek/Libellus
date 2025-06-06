class NotificationPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    user.librarian? || user == record.member
  end

  def create?
    user.librarian?
  end

  def update?
    user.librarian?
  end

  def destroy?
    user.librarian? || user == record.member
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
