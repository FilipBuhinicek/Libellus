require 'rails_helper'

RSpec.describe BookPolicy, type: :policy do
  subject { described_class }

  let(:book) { create(:book) }

  permissions :index?, :show? do
    context 'for any user' do
      let(:user) { nil }

      it 'grants access' do
        expect(subject).to permit(user, book)
      end
    end
  end

  permissions :create?, :update?, :destroy? do
    context 'when user is a librarian' do
      let(:user) { create(:librarian) }

      it 'grants access' do
        expect(subject).to permit(user, book)
      end
    end

    context 'when user is not a librarian' do
      let(:user) { create(:member) }

      it 'denies access' do
        expect(subject).not_to permit(user, book)
      end
    end
  end

  describe 'Scope' do
    it 'returns all books' do
      user = nil
      create_list(:book, 2)
      scope = Pundit.policy_scope!(user, Book)

      expect(scope).to match_array(Book.all)
    end
  end
end
