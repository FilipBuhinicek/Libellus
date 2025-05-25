require 'rails_helper'

RSpec.describe AuthorPolicy, type: :policy do
  subject { described_class }

  let(:author) { create(:author) }

  permissions :index?, :show?, :create?, :update?, :destroy? do
    context 'when user is a librarian' do
      let(:user) { create(:librarian) }

      it 'grants access' do
        expect(subject).to permit(user, author)
      end
    end

    context 'when user is a member' do
      let(:user) { create(:member) }

      it 'grants access to index and show' do
        expect(subject).to permit(user, author, :index?)
        expect(subject).to permit(user, author, :show?)
      end

      it 'denies access to create, update, and destroy' do
        expect(subject).not_to permit(user, author, :create?)
        expect(subject).not_to permit(user, author, :update?)
        expect(subject).not_to permit(user, author, :destroy?)
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
