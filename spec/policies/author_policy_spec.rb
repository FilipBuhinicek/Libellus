require 'rails_helper'

RSpec.describe AuthorPolicy, type: :policy do
  subject { described_class }

  let(:author) { create(:author) }

  permissions :index?, :show? do
    context 'for any user' do
      let(:user) { nil }

      it 'grants access' do
        expect(subject).to permit(user, author)
      end
    end
  end

  permissions :create?, :update?, :destroy? do
    context 'when user is a librarian' do
      let(:user) { create(:librarian) }

      it 'grants access' do
        expect(subject).to permit(user, author)
      end
    end

    context 'when user is not a librarian' do
      let(:user) { create(:member) }

      it 'denies access' do
        expect(subject).not_to permit(user, author)
      end
    end
  end

  describe 'Scope' do
    it 'returns all authors' do
      user = nil

      create_list(:author, 2)
      scope = Pundit.policy_scope!(user, Author)

      expect(scope).to match_array(Author.all)
    end
  end
end
