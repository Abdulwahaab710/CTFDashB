module Mutations
  class UpdateCategory < BaseMutation
    argument :id, ID, required: true
    argument :name, String, required: false
    argument :description, String, required: false

    type Types::CategoryType

    def resolve(id: nil, name: nil, description: nil)
      Category.find!(id)
        &.update({name: name, description: description}.compact!)
    end
  end
end
