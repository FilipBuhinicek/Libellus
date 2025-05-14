# == Schema Information
#
# Table name: users
#
#  id                :integer          not null, primary key
#  first_name        :string           not null
#  last_name         :string           not null
#  email             :string           not null
#  password          :string
#  type              :string           not null
#  employment_date   :date
#  termination_date  :date
#  membership_start  :date
#  membership_end    :date
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#

class Librarian < User
  validates :employment_date, presence: true
  validate :termination_after_employment, if: -> { termination_date.present? }

  private

  def termination_after_employment
    if termination_date < employment_date
      errors.add(:termination_date, "must be after employment date")
    end
  end
end
