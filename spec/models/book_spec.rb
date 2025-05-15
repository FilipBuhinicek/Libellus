require 'rails_helper'

RSpec.describe Book, type: :model do
  subject { build(:book) }

  describe 'associations' do
    it { should belong_to(:author).optional }
    it { should have_many(:borrowings) }
    it { should have_many(:reservations) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_length_of(:title).is_at_most(255) }

    it { should validate_numericality_of(:published_year).only_integer }
    it 'validates published_year to be <= current year' do
      subject.published_year = Date.current.year + 1
      expect(subject).not_to be_valid
    end

    it { should validate_length_of(:description).is_at_most(2000) }

    it { should validate_numericality_of(:copies_available).only_integer.is_greater_than_or_equal_to(0) }
  end

  describe 'factories' do
    it 'has a valid factory' do
      expect(subject).to be_valid
    end

    it 'is valid without an author' do
      subject.author = nil
      expect(subject).to be_valid
    end

    it 'is invalid without a title' do
      subject.title = nil
      expect(subject).not_to be_valid
    end
  end
end
