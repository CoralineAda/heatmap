require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SiteSection do

  before do
    @site_section = SiteSection.make(:root_url => 'foo')
  end
  
  it 'returns its root page' do
    @root_page = SitePage.make(:slug => 'foo', :site_section => @site_section)
    @site_section.root_page.should == @root_page
  end
  
  it 'updates its root site page URL if its root_url changes' do
    @root_page = SitePage.make(:slug => 'foo', :site_section => @site_section)
    @site_section.root_url = 'flubber'
    @site_section.save
    @root_page = SitePage.last
    @root_page.url.should == @site_section.reload.root_url
  end

  it "updates its site pages' URLs if its root_url changes" do
    5.times{ @site_section.site_pages << SitePage.make }
    @site_section.root_url = 'flubber'
    @site_section.save
    @site_section.reload
    @site_section.site_pages.each{ |sp| sp.url[0..(@site_section.root_url.size - 1)].should == @site_section.root_url }
  end

  it 'identifies its root page navbar link' do
    @root_page = SitePage.make(:slug => 'food', :site_section => @site_section)
    @site_section.reload.root_page_navbar_link.should == @root_page.reload.navbar_items.first
  end

  it 'can be converted to a hash' do
    @ss = SiteSection.make(:root_url => '/trolls/', :name => 'All About Trolls')
    @sp = SitePage.make_unsaved(:name => 'Something', :slug => '/trolls/', :site_section => @ss)
    @sp.save
    @sp.publish!
    _to_hash = @ss.reload.to_hash
    _to_hash.is_a?(Hash).should be_true
    _to_hash[:name].should == @ss.name
    _to_hash[:title].should == @ss.name
    _to_hash[:url].should == @sp.url
  end

  it 'returns its root page\'s navbar link' do
    @ss = SiteSection.make(:root_url => '/storms/', :name => 'Send Storms Now')
    @sp = SitePage.make_unsaved(:name => 'Send Storms Now', :slug => '/storms/', :site_section => @ss)
    @sp.save
    @sp.publish!
    @ss.reload.root_page_navbar_link.should == @sp.reload.navbar_items.roots.first
  end
  
end
