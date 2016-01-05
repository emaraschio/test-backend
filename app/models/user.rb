class User < Sequel::Model
  include Shield::Model
  one_to_many :tasks

  def self.fetch(username)
    find(:username => username)
  end

  def task_count
    self.tasks_dataset.count
  end
end
