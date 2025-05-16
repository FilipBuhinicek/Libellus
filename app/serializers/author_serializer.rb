class AuthorSerializer
  include JSONAPI::Serializer
  has_many :books
  attributes :first_name, :last_name, :biography
end
