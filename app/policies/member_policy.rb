class MemberPolicy < ApplicationPolicy
  def index?
    user.librarian?
  end

  def show?
    user.librarian? || user == record
  end

  def create?
    true
  end

  def update?
    user == record
  end

  def destroy?
    user.librarian? || user == record
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
