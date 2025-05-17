require 'rails_helper'

RSpec.describe NotificationPolicy, type: :policy do
  subject { described_class }

  let(:notification) { create(:notification) }

  permissions :index? do
    context 'for any user' do
      let(:user) { nil }

      it 'grants access' do
        expect(subject).to permit(user, notification)
      end
    end
  end


  permissions :create? do
    context 'when user is a librarian' do
      let(:user) { create(:librarian) }

      it 'grants access' do
        expect(subject).to permit(user, notification)
      end
    end

    context 'when user is not a librarian' do
      let(:user) { create(:member) }

      it 'denies access' do
        expect(subject).not_to permit(user, notification)
      end
    end
  end

  permissions :show?, :destroy? do
    context 'when user is a librarian' do
      let(:user) { create(:librarian) }

      it 'grants access' do
        expect(subject).to permit(user, notification)
      end
    end

    context 'when user is a member and owner' do
      let(:user) { create(:member) }
      let(:notification) { create(:notification, member: user) }

      it 'grants access' do
        expect(subject).to permit(user, notification)
      end
    end

    context 'when user is a member but not owner' do
      let(:user) { create(:member) }

      it 'grants access' do
        expect(subject).not_to permit(user, notification)
      end
    end
  end


  permissions :update? do
    context 'when user is a librarian' do
      let(:user) { create(:librarian) }

      it 'grants access' do
        expect(subject).to permit(user, notification)
      end
    end

    context 'when user is not a librarian' do
      let(:user) { create(:member) }

      it 'denies access' do
        expect(subject).not_to permit(user, notification)
      end
    end
  end

  describe 'Scope' do
    context 'when user is librarian' do
      it 'returns all notifications' do
        user = create(:librarian)

        create_list(:notification, 2)
        scope = Pundit.policy_scope!(user, Notification)

        expect(scope).to match_array(Notification.all)
      end
    end

    context 'when user is member' do
      it 'returns all notifications where owner' do
        user = create(:member)

        create_list(:notification, 2)
        scope = Pundit.policy_scope!(user, Notification)

        expect(scope).to match_array(Notification.where(user_id: user.id))
      end
    end
  end
end
