# == Schema Information
#
# Table name: reservations
#
#  id                :integer          not null, primary key
#  reservation_date  :date             not null
#  expiration_date   :date             not null
#  user_id           :integer          not null
#  book_id           :integer          not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_reservations_on_book_id    (book_id)
#  index_reservations_on_user_id    (user_id)
#

class Reservation < ApplicationRecord
  belongs_to :member, class_name: "Member", foreign_key: "user_id"
  belongs_to :book

  validates :reservation_date, presence: true
  validates :expiration_date, presence: true
  validate :expiration_date_after_reservation_date

  private

  def expiration_date_after_reservation_date
    return if reservation_date.blank? || expiration_date.blank?

    if expiration_date <= reservation_date
      errors.add(:expiration_date, "must be after reservation date")
    end
  end
end
