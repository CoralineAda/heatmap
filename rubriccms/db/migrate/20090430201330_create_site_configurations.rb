class CreateSiteConfigurations < ActiveRecord::Migration
  def self.up
    create_table :site_configurations do |t|
      t.string  :site_name
      t.text    :default_meta_description
      t.text    :default_meta_keywords
      t.boolean :include_site_section_in_window_title, :default => true
      t.string  :window_title_separator, :default => ' - '
      t.integer :maximum_file_size_for_flash_asset
      t.integer :maximum_file_size_for_image_asset
      t.integer :maximum_file_size_for_pdf_asset
      t.integer :maximum_file_size_for_quicktime_asset
      t.boolean :active, :default => false
      t.timestamps
    end
    SiteConfiguration.create(
      :site_name => RubricCms::Config.site_name,
      :window_title_separator => RubricCms::Config.window_title_separator,
      :include_site_section_in_window_title => RubricCms::Config.include_site_section_in_window_title,
      :default_meta_description => RubricCms::Config.default_meta_description,
      :default_meta_keywords => RubricCms::Config.default_meta_keywords,
      :maximum_file_size_for_flash_asset => 15,
      :maximum_file_size_for_image_asset => 5,
      :maximum_file_size_for_pdf_asset => 20,
      :maximum_file_size_for_quicktime_asset => 15,
      :active => true
    )
  end

  def self.down
    drop_table :site_configurations
  end
end
