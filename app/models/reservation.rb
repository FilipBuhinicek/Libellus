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
end
