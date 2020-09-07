module Mutations
  class DestroyPage < BaseMutation
    argument :page, PageType, required: true

    type Boolean

    def resolve(page:)
      page.destroy
    end
  end
end
