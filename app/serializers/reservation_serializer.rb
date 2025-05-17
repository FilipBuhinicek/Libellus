class ReservationSerializer
  include JSONAPI::Serializer
  belongs_to :member, serializer: MemberSerializer do |borrowing|
    borrowing.member
  end
  belongs_to :book
  attributes :reservation_date, :expiration_date
end
