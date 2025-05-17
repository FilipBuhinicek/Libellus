class BorrowingSerializer
  include JSONAPI::Serializer
  belongs_to :member, serializer: MemberSerializer do |borrowing|
    borrowing.member
  end
  belongs_to :book
  attributes :borrow_date, :return_date, :due_date
end
