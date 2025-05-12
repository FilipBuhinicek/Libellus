# == Schema Information
#
# Table name: books
#
#  id                :integer          not null, primary key
#  title             :string
#  published_year    :integer
#  description       :text
#  book_type         :string
#  copies_available  :integer
#  author_id         :integer          not null
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
end
