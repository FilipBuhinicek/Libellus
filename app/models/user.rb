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

class User < ApplicationRecord
  has_many :notifications

  self.inheritance_column = :type

  validates :first_name, :last_name, :email, presence: true
  validates :email, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  def full_name
    "#{first_name} #{last_name}"
  end
end
