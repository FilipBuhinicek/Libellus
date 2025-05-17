class NotificationSerializer
  include JSONAPI::Serializer
  belongs_to :member, serializer: MemberSerializer do |borrowing|
    borrowing.member
  end
  attributes :title, :content, :sent_date
end
