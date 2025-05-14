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

class Member < User
  has_many :borrowings
  has_many :reservations

  validates :membership_start, presence: true
  validate :membership_end_after_start, if: -> { membership_end.present? }

  private

  def membership_end_after_start
    if membership_end < membership_start
      errors.add(:membership_end, "must be after membership start date")
    end
  end
end
