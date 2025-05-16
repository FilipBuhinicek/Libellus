class MemberSerializer
  include JSONAPI::Serializer
  has_many :borrowings
  has_many :reservations
  has_many :notifications
  attributes :first_name, :last_name, :email, :membership_start, :membership_end
end
