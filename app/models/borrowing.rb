# == Schema Information
#
# Table name: borrowings
#
#  id             :integer          not null, primary key
#  borrow_date    :date             not null
#  return_date    :date
#  due_date       :date             not null
#  user_id        :integer          not null
#  book_id        :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_borrowings_on_book_id   (book_id)
#  index_borrowings_on_user_id   (user_id)
#

class Borrowing < ApplicationRecord
  belongs_to :member, class_name: "Member", foreign_key: "user_id"
  belongs_to :book

  validates :borrow_date, presence: true
  validates :due_date, presence: true

  validate :due_date_after_borrow_date
  validate :return_date_after_borrow_date, if: -> { return_date.present? }

  private

  def due_date_after_borrow_date
    return if borrow_date.blank? || due_date.blank?
    errors.add(:due_date, "must be after borrow date") if due_date <= borrow_date
  end

  def return_date_after_borrow_date
    return if borrow_date.blank? || return_date.blank?
    errors.add(:return_date, "must be after borrow date") if return_date < borrow_date
  end
end
