class CreateSiteSections < ActiveRecord::Migration
  def self.up
    create_table :site_sections do |t|
      t.string  :name
      t.string  :root_url
      t.text    :meta_description
      t.text    :meta_keywords
      t.boolean :sidebar_enabled, :default => true
      t.boolean :navbar_enabled, :default => true
      t.boolean :active, :default => true
      t.integer :site_pages_count
      t.timestamps
    end
  end

  def self.down
    drop_table :site_sections
  end
end
