class AuthorPolicy < ApplicationPolicy
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
    user.librarian?
  end

  def destroy?
    user.librarian?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.all
    end
  end
end
