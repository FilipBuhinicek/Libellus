# == Schema Information
#
# Table name: users
#
#  id                :integer          not null, primary key
#  first_name        :string
#  last_name         :string
#  email             :string           not null
#  password          :string
#  type              :string
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

class Librarian < User
end
