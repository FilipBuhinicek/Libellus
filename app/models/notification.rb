# == Schema Information
#
# Table name: notifications
#
#  id           :integer          not null, primary key
#  title        :string
#  content      :text
#  sent_date    :date
#  user_id      :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_notifications_on_user_id  (user_id)
#

class Notification < ApplicationRecord
  belongs_to :user
end
