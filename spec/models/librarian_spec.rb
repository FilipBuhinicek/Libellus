require 'rails_helper'

RSpec.describe Librarian, type: :model do
  subject { build(:librarian) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is invalid without employment_date' do
      subject.employment_date = nil
      expect(subject).not_to be_valid
      expect(subject.errors[:employment_date]).to include("can't be blank")
    end

    it 'is valid without termination_date' do
      subject.termination_date = nil
      expect(subject).to be_valid
    end

    it 'is invalid if termination_date is before employment_date' do
      subject.termination_date = subject.employment_date - 1.day
      expect(subject).not_to be_valid
      expect(subject.errors[:termination_date]).to include("must be after employment date")
    end

    it 'is valid if termination_date is after employment_date' do
      subject.termination_date = subject.employment_date + 1.day
      expect(subject).to be_valid
    end
  end

  describe 'inheritance' do
    it 'is a subclass of User' do
      expect(Librarian < User).to be true
    end

    it 'has type set to Librarian' do
      expect(subject.type).to eq('Librarian')
    end
  end
end
