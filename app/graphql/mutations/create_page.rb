module Mutations
  class CreatePage < BaseMutation
    argument :path, String, required: true
    argument :html_content, String, required: true

    type Types::PageType

    def resolve(path:, html_content:)
      Page.create!(path:, path, html_content: html_content)
    end
  end
end
