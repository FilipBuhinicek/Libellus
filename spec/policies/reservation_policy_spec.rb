require 'rails_helper'

RSpec.describe ReservationPolicy, type: :policy do
  subject { described_class }

  let(:reservation) { create(:reservation) }

  permissions :index? do
    context 'for any user' do
      let(:user) { nil }

      it 'grants access' do
        expect(subject).to permit(user, reservation)
      end
    end
  end

  permissions :show?, :create?, :destroy? do
    context 'when user is a librarian' do
      let(:user) { create(:librarian) }

      it 'grants access' do
        expect(subject).to permit(user, reservation)
      end
    end

    context 'when user is a member and owner' do
      let(:user) { create(:member) }
      let(:reservation) { create(:reservation, member: user) }

      it 'grants access' do
        expect(subject).to permit(user, reservation)
      end
    end

    context 'when user is a member but not owner' do
      let(:user) { create(:member) }

      it 'denies access' do
        expect(subject).not_to permit(user, reservation)
      end
    end
  end

  permissions :update? do
    context 'when user is a librarian' do
      let(:user) { create(:librarian) }

      it 'grants access' do
        expect(subject).to permit(user, reservation)
      end
    end

    context 'when user is not a librarian' do
      let(:user) { create(:member) }

      it 'denies access' do
        expect(subject).not_to permit(user, reservation)
      end
    end
  end

  describe 'Scope' do
    context 'when user is a librarian' do
      it 'returns all reservations' do
        user = create(:librarian)
        create_list(:reservation, 2)
        scope = Pundit.policy_scope!(user, Reservation)

        expect(scope).to match_array(Reservation.all)
      end
    end

    context 'when user is a member' do
      it 'returns all reservations from member' do
        user = create(:member)
        create_list(:reservation, 2)
        scope = Pundit.policy_scope!(user, Reservation)

        expect(scope).to match_array(Reservation.where(user_id: user.id))
      end
    end
  end
end
