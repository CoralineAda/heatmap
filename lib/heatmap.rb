%w{ models controllers helpers }.each do |dir|
  path = File.join(File.dirname(__FILE__), 'app', dir)
  $LOAD_PATH << path
  ActiveSupport::Dependencies.load_paths << path
  ActiveSupport::Dependencies.load_once_paths.delete(path)
end

module Heatmap

  def heatmap(histogram={})
    html = %{<div class="heatmap">}
    histogram.keys.sort{|a,b| histogram[a] <=> histogram[b]}.reverse.each do |k|
      next if histogram[k] < 1
      _max = histogram_max(histogram)
      _size = element_size(histogram[k], _max)
      _heat = element_heat(histogram[k], _max)
      html << %{
        <span class="heatmap_element" style="color: ##{_heat}#{_heat}#{_heat}; font-size: #{_size}px;">#{k}</span>
      }
    end
    html << %{<br style="clear: both;" /></div>}
  end

  def histogram_max(histogram)
    histogram.map{|k,v| histogram[k]}.max * 2
  end

  def element_size(val, max)
   (val / (max / 2.0)) * 100
  end
  
  def element_heat(val, max)
    sprintf("%02x" % (200 - ((200.0 / max) * val)))
  end

end