class CreateCmsPageSeoData < ActiveRecord::Migration
  def change
    create_table :cms_page_seo_data do |t|
      t.integer :page_id, null: false
      t.string :title
      t.text :description
    end

    add_index :cms_page_seo_data, :page_id
  end
end
