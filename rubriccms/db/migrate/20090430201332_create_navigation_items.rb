class CreateNavigationItems < ActiveRecord::Migration
  def self.up
    create_table :navigation_items do |t|
      t.integer :page_id
      t.string  :link_text
      t.string  :link_title
      t.text    :url
      t.integer :site_page_id
      t.boolean :nofollow
      t.integer :position
      t.string  :type
      t.integer :site_section_id
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
      t.boolean :popup, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :navigation_items
  end
end
