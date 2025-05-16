require 'rails_helper'

RSpec.describe Notification, type: :model do
  subject { build(:notification) }

  describe 'associations' do
    it { should belong_to(:member).class_name('Member').with_foreign_key('user_id') }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_length_of(:title).is_at_most(255) }
    it { should validate_presence_of(:content) }
    it { should validate_presence_of(:sent_date) }

    it 'is invalid if sent_date is in the future' do
      notification = build(:notification, sent_date: Date.today + 2)
      expect(notification).not_to be_valid
      expect(notification.errors[:sent_date]).to include("can't be in the future")
    end

    it 'is valid if sent_date is today or in the past' do
      notification = build(:notification, sent_date: Date.today)
      expect(notification).to be_valid
    end
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:notification)).to be_valid
    end
  end
end
