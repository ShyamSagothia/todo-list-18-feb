class CollaboratorSerializer
  include Alba::Resource

  attributes :id, :email

  attribute :done, if: -> { params[:detailed] }
end
