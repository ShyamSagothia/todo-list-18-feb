class TodoList < ApplicationRecord
  belongs_to :user
  has_many :todos, dependent: :destroy
  accepts_nested_attributes_for :todos
  validates :name, presence: true
end
