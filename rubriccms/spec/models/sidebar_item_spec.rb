require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SidebarItem do

  before do
    @ss = SiteSection.make
    @sp = SitePage.make(:site_section => @ss)
    @sp.publish!
    @sb = @sp.reload.sidebar_items.first
  end

  it "should be disabled if its site section is inactive" do
    @ss.sidebar_enabled = false
    @ss.save
    @sb.reload.enabled?.should be_false
  end

  it "should be enabled if its site section is active" do
    @ss.sidebar_enabled = true
    @ss.save
    @sb.reload.enabled?.should be_true
  end

end
