class ReservationSerializer
  include JSONAPI::Serializer
  belongs_to :member, serializer: MemberSerializer
  belongs_to :book
  attributes :reservation_date, :expiration_date
end
