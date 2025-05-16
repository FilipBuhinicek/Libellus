require 'rails_helper'

RSpec.describe MemberPolicy, type: :policy do
  subject { described_class }

  let(:member) { create(:member) }

  permissions :index? do
    context 'when user is a librarian' do
      let(:user) { create(:librarian) }

      it 'grants access' do
        expect(subject).to permit(user, member)
      end
    end

    context 'when user is not a librarian' do
      let(:user) { create(:member) }

      it 'denies access' do
        expect(subject).not_to permit(user, member)
      end
    end
  end

  permissions :show?, :destroy? do
    context 'when user is a librarian' do
      let(:user) { create(:librarian) }

      it 'grants access' do
        expect(subject).to permit(user, member)
      end
    end

    context 'when user is a member and owner' do
      let(:user) { member }

      it 'grants access' do
        expect(subject).to permit(user, member)
      end
    end

    context 'when user is a member but not owner' do
      let(:user) { create(:member) }

      it 'grants access' do
        expect(subject).not_to permit(user, member)
      end
    end
  end

  permissions :create? do
    context 'for any user' do
      let(:user) { nil }

      it 'grants access' do
        expect(subject).to permit(user, member)
      end
    end
  end

  permissions :update? do
    context 'when user is a member and the owner' do
      let(:user) { member }

      it 'grants access' do
        expect(subject).to permit(user, member)
      end
    end

    context 'when user is a member but not the owner' do
      let(:user) { create(:member) }

      it 'denies access' do
        expect(subject).not_to permit(user, member)
      end
    end
  end

  describe 'Scope' do
    it 'returns all librarirans' do
      user = nil

      create_list(:member, 2)
      scope = Pundit.policy_scope!(user, Member)

      expect(scope).to match_array(Member.all)
    end
  end
end
