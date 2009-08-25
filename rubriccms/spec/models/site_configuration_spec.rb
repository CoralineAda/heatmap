require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SiteConfiguration do

  describe 'current active configuration' do
    
		it 'retrieves the site_name attribute'
		it 'retrieves the default_meta_description attribute'
		it 'retrieves the default_meta_keywords attribute'
		it 'retrieves the include_site_section_in_window_title attribute'
		it 'retrieves the window_title_separator attribute'
		it 'retrieves the maximum_file_size_for_flash_asset attribute'
		it 'retrieves the maximum_file_size_for_image_asset attribute'
		it 'retrieves the maximum_file_size_for_pdf_asset attribute'
		it 'retrieves the maximum_file_size_for_quicktime_asset attribute'
		it 'retrieves the active attribute'

  end

  it 'only allows one configuration to be active at a time'
  
  it 'defaults to the plugin configuration from RubricCms::Config'
  
end
