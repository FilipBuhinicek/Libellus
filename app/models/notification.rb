# == Schema Information
#
# Table name: notifications
#
#  id           :integer          not null, primary key
#  title        :string           not null
#  content      :text             not null
#  sent_date    :date             not null
#  user_id      :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_notifications_on_user_id  (user_id)
#

class Notification < ApplicationRecord
  belongs_to :member, class_name: "Member", foreign_key: "user_id"

  validates :title, presence: true, length: { maximum: 255 }
  validates :content, presence: true
  validates :sent_date, presence: true

  validate :sent_date_not_in_future

  private

  def sent_date_not_in_future
    if sent_date.present? && sent_date > Date.today
      errors.add(:sent_date, "can't be in the future")
    end
  end
end
