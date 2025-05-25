class AuthorSerializer
  include JSONAPI::Serializer
  has_many :books
  attributes :first_name, :last_name, :biography
  attribute :full_name do |author|
    author.full_name
  end
end
