class CreateSitePages < ActiveRecord::Migration
  def self.up
    create_table :site_pages do |t|
      t.string  :name
      t.string  :page_title
      t.text    :meta_keywords
      t.text    :meta_description
      t.string  :slug
      t.string  :url
      t.text    :content
      t.integer :user_id
      t.text    :last_modified_comment
      t.integer :site_section_id
      t.integer :version
      t.integer :parent_id
      t.boolean :home_page, :default => false
			t.string  :state, :null => :no, :default => 'draft'
      t.integer :lft
      t.integer :rgt
      t.timestamps
    end
    add_index :site_pages, :url
    add_index :site_pages, :home_page
  end

  def self.down
    drop_table :site_pages
  end
end
