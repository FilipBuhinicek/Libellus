class ModifyConstraintsOnBorrowings < ActiveRecord::Migration[8.0]
  def change
    change_column_null :borrowings, :return_date, true
    change_column_null :borrowings, :due_date, false
  end
end
