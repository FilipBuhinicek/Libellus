require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build(:user) }

  describe 'validations' do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    it { should allow_value('user@example.com').for(:email) }
    it { should_not allow_value('invalid_email').for(:email) }
  end

  describe '#full_name' do
    it 'returns the concatenated first and last name' do
      user = build(:user, first_name: 'John', last_name: 'Doe')
      expect(user.full_name).to eq('John Doe')
    end
  end

  describe '#librarian?' do
    it 'returns true if type is librarian' do
      user = build(:user, type: UserType::LIBRARIAN)
      expect(user.librarian?).to be true
    end

    it 'returns false if type is not librarian' do
      user = build(:user, type: UserType::MEMBER)
      expect(user.librarian?).to be false
    end
  end

  describe '#member?' do
    it 'returns true if type is member' do
      user = build(:user, type: UserType::MEMBER)
      expect(user.member?).to be true
    end

    it 'returns false if type is not member' do
      user = build(:user, type: UserType::LIBRARIAN)
      expect(user.member?).to be false
    end
  end
end
