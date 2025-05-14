class AddValidationToModels < ActiveRecord::Migration[8.0]
  def change
    change_column :authors, :first_name, :string, null: false
    change_column :authors, :biography, :text, limit: 2000

    change_column :books, :title, :string, null: false, limit: 255
    change_column :books, :author_id, :integer, null: true

    change_column :users, :first_name, :string, null: false
    change_column :users, :last_name, :string, null: false

    change_column :notifications, :title, :string, null: false, limit: 255
    change_column :notifications, :content, :text, null: false
    change_column :notifications, :sent_date, :date, null: false
  end
end
