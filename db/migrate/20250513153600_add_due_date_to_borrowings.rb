class AddDueDateToBorrowings < ActiveRecord::Migration[8.0]
  def change
    add_column :borrowings, :due_date, :date
  end
end
