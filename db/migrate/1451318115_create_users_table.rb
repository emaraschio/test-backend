Sequel.migration do
  change do
    create_table(:users) do
      primary_key :id
      column :username, String, null: false
      column :crypted_password, String, null: false
      column :email, String, null: false
      column :phone_number, String, null: false
      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
      index :username, unique: true
    end
  end
end
