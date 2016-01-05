Sequel.migration do
  change do
    create_table(:tasks) do
      primary_key :id
      foreign_key :user_id, :users
      String :category
      String :description
      Date :due_date
      column :complete, :boolean, default:false, null:false
    end
  end
end
