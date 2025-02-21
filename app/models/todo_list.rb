class TodoList < ApplicationRecord
  belongs_to :user
  has_many :todos, dependent: :destroy
  has_many :collaborations, dependent: :destroy
  has_many :collaborators, through: :collaborations, source: :user
  accepts_nested_attributes_for :todos
  validates :name, presence: true
end
