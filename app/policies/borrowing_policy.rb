class BorrowingPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    user.librarian?
  end

  def create?
    user.librarian?
  end

  def update?
    user.librarian?
  end

  def destroy?
    user.librarian?
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
