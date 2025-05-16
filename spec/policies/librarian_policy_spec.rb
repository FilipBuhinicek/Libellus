require 'rails_helper'

RSpec.describe LibrarianPolicy, type: :policy do
  subject { described_class }

  let(:librarian) { create(:librarian) }

  permissions :index?, :show?, :create?, :destroy? do
    context 'when user is a librarian' do
      let(:user) { create(:librarian) }

      it 'grants access' do
        expect(subject).to permit(user, librarian)
      end
    end

    context 'when user is not a librarian' do
      let(:user) { create(:member) }

      it 'denies access' do
        expect(subject).not_to permit(user, librarian)
      end
    end
  end

  permissions :update? do
    context 'when user is a librarian and the owner' do
      let(:user) { librarian }

      it 'grants access' do
        expect(subject).to permit(user, librarian)
      end
    end

    context 'when user is a librarian but not the owner' do
      let(:user) { create(:librarian) }

      it 'denies access' do
        expect(subject).not_to permit(user, librarian)
      end
    end
  end

  describe 'Scope' do
    it 'returns all librarirans' do
      user = nil

      create_list(:librarian, 2)
      scope = Pundit.policy_scope!(user, Librarian)

      expect(scope).to match_array(Librarian.all)
    end
  end
end
