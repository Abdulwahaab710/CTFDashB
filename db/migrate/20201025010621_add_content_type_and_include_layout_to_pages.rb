class AddContentTypeAndIncludeLayoutToPages < ActiveRecord::Migration[5.2]
  def change
    add_column :pages, :content_type, :string
    add_column :pages, :include_layout, :boolean
  end
end
