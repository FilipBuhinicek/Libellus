class BookSerializer
  include JSONAPI::Serializer
  belongs_to :author
  attributes :title, :published_year, :description, :book_type, :copies_available
end
