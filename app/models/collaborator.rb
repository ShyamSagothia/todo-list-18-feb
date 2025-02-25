class Collaborator < ApplicationRecord
  belongs_to :user
  belongs_to :todo_list

  validates :user, uniqueness: true
  # validates :user_id {scope : user.id != user_id}
end
