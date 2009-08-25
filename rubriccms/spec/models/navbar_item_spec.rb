require File.dirname(__FILE__) + '/../spec_helper'

describe NavbarItem do

  it 'should normalize its url correctly' do
    @navbar_item_1 = NavbarItem.make(:url => 'foo')
    @navbar_item_1.url.should == '/foo/'

    @navbar_item_2 = NavbarItem.make(:url => 'foo/bar')
    @navbar_item_2.url.should == '/foo/bar/'

    @navbar_item_3 = NavbarItem.make(:url => '/foo/bar')
    @navbar_item_3.url.should == '/foo/bar/'

    @navbar_item_4 = NavbarItem.make(:url => '/foo/bar/')
    @navbar_item_4.url.should == '/foo/bar/'
  end

  describe 'active status' do
  
    it 'defaults to active if there is no associated site section' do
      @navbar_item_1 = NavbarItem.make(:url => 'foo')
      @navbar_item_1.reload.enabled?.should be_true
    end
    
    it 'is active if its associated site section has enabled the navbar' do
      @site_section = SiteSection.make(:navbar_enabled => true)
      @site_page = SitePage.make(:site_section => @site_section)
      @site_page.publish!
      @site_page.reload.navbar_items.first.enabled?.should be_true
    end
    
    it 'is inactive if its associated site section has disabled the navbar' do
      @site_section = SiteSection.make(:navbar_enabled => true)
      @site_page = SitePage.make(:site_section => @site_section)
      @site_page.publish!
      @site_section.update_attribute(:navbar_enabled, false)
      @site_page.reload.navbar_items.first.enabled?.should be_false
    end    
    
  end
  
  describe 'site page association' do
  
    before do
      @site_page = SitePage.make
      @site_page.publish!
      @navbar_item = @site_page.reload.navbar_items.first
    end
    
    it 'should default its url to that of its associated site page' do
      @navbar_item.url.should == @site_page.url
    end
    
    it 'should return url of the last published version of its associated site page' do
      @site_page.update_attribute(:slug, 'foo')
      @navbar_item.reload.url.should == @site_page.reload.url
    end
    
    it 'should create a nested navbar item' do
      @ss = SiteSection.make(:root_url => 'ygdrrsil')
      @root_page = SitePage.make_unsaved(:slug => @ss.root_url, :site_section => @ss)
      @root_page.save
      @root_page.publish!
      @non_root_page = SitePage.make_unsaved(:site_section => @ss)
      @non_root_page.save
      @non_root_page.publish!
      @non_root_page.reload.navbar_items.last.parent.should_not be_nil
    end
    
  end
  
end
