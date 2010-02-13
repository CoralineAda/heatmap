require 'test_helper'

class HeatmapTest < ActiveSupport::TestCase

  include Heatmap

  test "calculates max value" do
    histogram ||= { 'Foo' => 13, 'Bar' => 15 }
    assert_equal 30, histogram_max(histogram)
  end

  test "determines element size" do
    histogram ||= { 'Foo' => 13, 'Bar' => 15 }
    assert_equal 51, element_size(histogram, 'Foo')
  end

  test "determines element heat" do
    histogram ||= { 'Foo' => 13, 'Bar' => 15 }
    assert_match "E", element_heat(histogram, 13)
  end
  
end
