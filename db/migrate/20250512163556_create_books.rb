class CreateBooks < ActiveRecord::Migration[8.0]
  def change
    create_table :books do |t|
      t.string :title
      t.integer :published_year, null: true
      t.text :description, null: true
      t.string :book_type
      t.integer :copies_available
      t.references :author, null: false, foreign_key: true

      t.timestamps
    end
  end
end
