class TodoList < ApplicationRecord
  belongs_to :user
  has_many :todos, dependent: :destroy
  has_many :collaborators, dependent: :destroy
  has_many :collaborators_users, through: :collaborators, source: :user

  validates :user, presence: true 
  validates :heading, presence: true 
end
