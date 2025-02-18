class Collaborator < ApplicationRecord
  belongs_to :user
  belongs_to :todo_list
end
