class User < Sequel::Model
  include Shield::Model
  one_to_many :tasks

  def self.fetch(username)
    find(:username => username)
  end
end
