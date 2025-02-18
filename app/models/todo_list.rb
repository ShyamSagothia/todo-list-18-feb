class TodoList < ApplicationRecord
  belongs_to :user
  has_many :todos
  has_many :collaborators
  has_many :users, through: :collaborators 
end
