require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe MediaAsset do

  it 'should identify image assets' do
    @asset = ImageAsset.make
    @asset.image?.should be_true
    @asset.flash?.should be_false
    @asset.pdf?.should be_false
    @asset.quicktime?.should be_false
  end

  it 'should identify flash assets' do
    @asset = FlashAsset.make
    @asset.image?.should be_false
    @asset.flash?.should be_true
    @asset.pdf?.should be_false
    @asset.quicktime?.should be_false
  end

  it 'should identify pdf assets' do
    @asset = PdfAsset.make
    @asset.image?.should be_false
    @asset.flash?.should be_false
    @asset.pdf?.should be_true
    @asset.quicktime?.should be_false
  end

  it 'should identify quicktime assets' do
    @asset = QuicktimeAsset.make
    @asset.image?.should be_false
    @asset.flash?.should be_false
    @asset.pdf?.should be_false
    @asset.quicktime?.should be_true
  end

  it 'should provide a URL without a cache suffix' do
    url = '/assets/media/pdf/1/original/2007-Annual-Report.pdf?1243219799'
    MediaAsset.canonical_url(url).should == '/assets/media/pdf/1/original/2007-Annual-Report.pdf'
  end
  
end
