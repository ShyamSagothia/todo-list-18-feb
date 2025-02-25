class TodoMiniSerializer
  include Alba::Resource

  root_key :Data

  attributes :id, :heading, :content
end
