class CreateMediaAssets < ActiveRecord::Migration
  def self.up
    create_table :media_assets do |t|
      t.string    :name
      t.string    :description
      t.string    :type
      t.boolean   :active, :default => true
      t.string    :media_file_name
      t.string    :media_content_type
      t.integer   :media_file_size
      t.datetime  :media_updated_at
      t.integer   :position
    end
  end

  def self.down
    drop_table :media_assets
  end
end
