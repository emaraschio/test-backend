class Task < Sequel::Model
  many_to_one :owner, class: :User, key: :user_id
end
