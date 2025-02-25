class TodoList < ApplicationRecord
  belongs_to :user
  has_many :todos, dependent: :destroy
  has_many :collaborations, dependent: :destroy
  has_many :collaborators, through: :collaborations, source: :user
  accepts_nested_attributes_for :todos
  validates :name, presence: true
  validate :owner_cannot_be_a_collaborator

  private

  def owner_cannot_be_a_collaborator
    return unless collaborator_ids.include?(user_id)

    errors.add(:collaborator_ids, 'owner cannot be a collaborator')
  end
end
