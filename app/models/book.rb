# == Schema Information
#
# Table name: books
#
#  id                :integer          not null, primary key
#  title             :string           not null
#  published_year    :integer
#  description       :text
#  book_type         :string
#  copies_available  :integer
#  author_id         :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_books_on_author_id  (author_id)
#

class Book < ApplicationRecord
  belongs_to :author, optional: true

  has_many :borrowings
  has_many :reservations

  validates :title, presence: true, length: { maximum: 255 }
  validates :published_year, numericality: { only_integer: true, less_than_or_equal_to: Date.current.year }, allow_nil: true
  validates :description, length: { maximum: 2000 }, allow_blank: true
  validates :copies_available, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
