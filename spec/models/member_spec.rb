require 'rails_helper'

RSpec.describe Member, type: :model do
  subject { build(:member) }

  describe 'associations' do
    it { should have_many(:borrowings).with_foreign_key('user_id') }
    it { should have_many(:reservations).with_foreign_key('user_id') }
    it { should have_many(:notifications).with_foreign_key('user_id') }
  end

  describe 'validations' do
    it { should validate_presence_of(:membership_start) }

    context 'membership_end validations' do
      it 'is invalid if membership_end is before membership_start' do
        subject.membership_start = Date.today
        subject.membership_end = Date.yesterday
        expect(subject).not_to be_valid
        expect(subject.errors[:membership_end]).to include("must be after membership start date")
      end

      it 'is valid if membership_end is after membership_start' do
        subject.membership_start = Date.today
        subject.membership_end = Date.tomorrow
        expect(subject).to be_valid
      end

      it 'is valid if membership_end is nil' do
        subject.membership_end = nil
        expect(subject).to be_valid
      end
    end
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(subject).to be_valid
    end
  end
end
