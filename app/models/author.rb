# == Schema Information
#
# Table name: authors
#
#  id           :integer          not null, primary key
#  first_name   :string           not null
#  last_name    :string
#  biography    :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Author < ApplicationRecord
  has_many :books

  validates :first_name, presence: true
  validates :biography, length: { maximum: 2000 }, allow_blank: true

  def full_name
    "#{first_name} #{last_name}"
  end
end
