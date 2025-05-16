class LibrarianSerializer
  include JSONAPI::Serializer
  attributes :first_name, :last_name, :email, :employment_date, :termination_date
end
