class Todo < ApplicationRecord

  include AASM


  validates :heading, presence: true, length: {minimum:3}
  validates :content, presence: true, length: {minimum:5}

  belongs_to :todo_list

  aasm column: 'status' do
    state :pending, initial: true
    state :in_progress
    state :completed

    event :start do
      transitions from: :pending, to: :in_progress
    end

    event :complete do
      transitions from: :in_progress, to: :completed
    end

  end
end
