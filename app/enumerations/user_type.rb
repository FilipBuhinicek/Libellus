module UserType
  MEMBER = "Member"
  LIBRARIAN = "Librarian"

  ALL = [ MEMBER, LIBRARIAN ].freeze

  def self.valid?(value)
    ALL.include?(value)
  end
end
