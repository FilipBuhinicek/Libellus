class NotificationSerializer
  include JSONAPI::Serializer
  belongs_to :member, serializer: MemberSerializer
  attributes :title, :content, :sent_date
end
