class LibrarianPolicy < ApplicationPolicy
  def index?
    user.librarian?
  end

  def show?
    user.librarian?
  end

  def create?
    user.librarian?
  end

  def update?
    user.librarian? && user == record
  end

  def destroy?
    user.librarian?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
