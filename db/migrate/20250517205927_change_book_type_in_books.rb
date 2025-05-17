class ChangeBookTypeInBooks < ActiveRecord::Migration[8.0]
  def change
    change_column_default :books, :book_type, from: nil, to: "fiction"
    change_column_null :books, :book_type, false, "fiction"
  end
end
