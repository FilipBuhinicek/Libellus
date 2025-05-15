require 'rails_helper'

RSpec.describe Borrowing, type: :model do
  subject { build(:borrowing) }

  describe 'associations' do
    it { should belong_to(:member).class_name('Member') }
    it { should belong_to(:book) }
  end

  describe 'validations' do
    it { should validate_presence_of(:borrow_date) }
    it { should validate_presence_of(:due_date) }

    it 'is invalid if due_date is before or same as borrow_date' do
      subject.borrow_date = Date.today
      subject.due_date = Date.today
      expect(subject).not_to be_valid
      expect(subject.errors[:due_date]).to include("must be after borrow date")
    end

    it 'is invalid if return_date is before borrow_date' do
      subject.borrow_date = Date.today
      subject.return_date = Date.yesterday
      expect(subject).not_to be_valid
      expect(subject.errors[:return_date]).to include("must be after borrow date")
    end

    it 'is valid if return_date is after borrow_date' do
      subject.borrow_date = Date.today
      subject.return_date = Date.today + 5
      expect(subject).to be_valid
    end
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(subject).to be_valid
    end
  end
end
