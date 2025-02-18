class Todo < ApplicationRecord
  include AASM
  belongs_to :todo_list
  validates :title, presence: true
  aasm column: "status" do
    state :pending, initial: true
    state :completed

    event :complete do
      transitions from: :pending, to: :completed
    end
  end

  before_create :set_defaults

  private

  def set_defaults
    self.done = false if done.nil?
  end
end
