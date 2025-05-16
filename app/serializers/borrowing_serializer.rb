class BorrowingSerializer
  include JSONAPI::Serializer
  belongs_to :member, serializer: MemberSerializer
  belongs_to :book
  attributes :borrow_date, :return_date, :due_date
end
