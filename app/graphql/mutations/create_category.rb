module Mutations
  class CreateCategory < BaseMutation
    argument :name, String, required: true
    argument :description, String, required: false

    type Types::CategoryType

    def resolve(name: nil, description: nil)
      Category.create!(
        name: name,
      )
    end
  end
end
