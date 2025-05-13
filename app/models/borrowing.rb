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
  belongs_to :member, class_name: "Member"
  belongs_to :book
end
