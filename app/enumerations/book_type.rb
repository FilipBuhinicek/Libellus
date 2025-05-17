module BookType
  FICTION      = "fiction"
  NONFICTION   = "nonfiction"
  FANTASY      = "fantasy"
  SCIFI        = "scifi"
  MYSTERY      = "mystery"
  ROMANCE      = "romance"
  HORROR       = "horror"
  HISTORICAL   = "historical"
  BIOGRAPHY    = "biography"
  SELF_HELP    = "self_help"

  ALL = [
    FICTION,
    NONFICTION,
    FANTASY,
    SCIFI,
    MYSTERY,
    ROMANCE,
    HORROR,
    HISTORICAL,
    BIOGRAPHY,
    SELF_HELP
  ].freeze

  def self.valid?(value)
    ALL.include?(value)
  end
end
