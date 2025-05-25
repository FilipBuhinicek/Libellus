require 'rails_helper'

RSpec.describe BorrowingPolicy, type: :policy do
  subject { described_class }

  let(:borrowing) { create(:borrowing) }

  permissions :index? do
    context 'for any user' do
      let(:user) { nil }

      it 'grants access' do
        expect(subject).to permit(user, borrowing)
      end
    end
  end

  permissions :show?, :create?, :destroy? do
    context 'when user is a librarian' do
      let(:user) { create(:librarian) }

      it 'grants access' do
        expect(subject).to permit(user, borrowing)
      end
    end

    context 'when user is a member' do
      let(:user) { create(:member) }
      let(:borrowing) { create(:borrowing, member: user) }

      it 'denies access' do
        expect(subject).not_to permit(user, borrowing)
      end
    end
  end

  permissions :update? do
    context 'when user is a librarian' do
      let(:user) { create(:librarian) }

      it 'grants access' do
        expect(subject).to permit(user, borrowing)
      end
    end

    context 'when user is not a librarian' do
      let(:user) { create(:member) }

      it 'denies access' do
        expect(subject).not_to permit(user, borrowing)
      end
    end
  end

  describe 'Scope' do
    context 'when user is a librarian' do
      it 'returns all borrowings' do
        user = create(:librarian)
        create_list(:borrowing, 2)
        scope = Pundit.policy_scope!(user, Borrowing)

        expect(scope).to match_array(Borrowing.all)
      end
    end

    context 'when user is a member' do
      it 'returns all borrowings from member' do
        user = create(:member)
        create_list(:borrowing, 2)
        scope = Pundit.policy_scope!(user, Borrowing)

        expect(scope).to match_array(Borrowing.where(user_id: user.id))
      end
    end
  end
end
