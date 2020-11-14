module Mutations
  class UpdatePage < BaseMutation
    argument :id, ID, required: true
    argument :path, String, required: false
    argument :html_content, String, required: false

    type Types::PageType

    def resolve(id:, path:, html_content:)
      Page.find(id).update({path: path, html_content: html_content}.compact!)
    end
  end
end
