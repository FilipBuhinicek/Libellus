require 'rails_helper'

RSpec.describe Author, type: :model do
  subject { build(:author) }

  describe 'associations' do
    it { should have_many(:books) }
  end

  describe 'validations' do
    it { should validate_presence_of(:first_name) }
    it { should validate_length_of(:biography).is_at_most(2000) }
  end

  describe 'factories' do
    it 'has a valid factory' do
      expect(subject).to be_valid
    end

    it 'is invalid without a first_name' do
      subject.first_name = nil
      expect(subject).not_to be_valid
    end

    it 'is valid with optional last_name' do
      subject.last_name = nil
      expect(subject).to be_valid
    end

    it 'is invalid if biography is too long' do
      subject.biography = 'a' * 2001
      expect(subject).not_to be_valid
    end
  end
end
