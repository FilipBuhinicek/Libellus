require 'rails_helper'

RSpec.describe Reservation, type: :model do
  subject { build(:reservation) }

  describe 'associations' do
    it { should belong_to(:member).class_name('Member').with_foreign_key('user_id') }
    it { should belong_to(:book) }
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is invalid without reservation_date' do
      subject.reservation_date = nil
      expect(subject).not_to be_valid
    end

    it 'is invalid without expiration_date' do
      subject.expiration_date = nil
      expect(subject).not_to be_valid
    end

    it 'is invalid if expiration_date is before or same as reservation_date' do
      subject.expiration_date = subject.reservation_date
      expect(subject).not_to be_valid
      expect(subject.errors[:expiration_date]).to include("must be after reservation date")

      subject.expiration_date = subject.reservation_date - 1
      expect(subject).not_to be_valid
      expect(subject.errors[:expiration_date]).to include("must be after reservation date")
    end
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:reservation)).to be_valid
    end
  end
end
