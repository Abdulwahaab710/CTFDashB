module Mutations
  class DestroyCategory < BaseMutation
    argument :category, CategoryType, required: true

    type Boolean

    def resolve(category:)
      category.destroy
    end
  end
end
