class UpdateUsersRemoveRoleAddTerminationDatDDe < ActiveRecord::Migration[8.0]
  def change
    remove_column :users, :role, :string
    add_column :users, :termination_date, :date
  end
end
