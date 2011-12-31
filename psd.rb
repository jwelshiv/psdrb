#!/usr/bin/ruby
require 'rmagick'

class Psd
  include Magick
  
  def initialize(file)
    Magick.set_log_format("\n")
    
    puts "loading #{file}"
    file = load(file)
    puts "#{self.layers.count} layers loaded"
    file
  end
  
  def load(file)
    @file = Image.read(file){}
    self.name = file
  end
  
  def to_s
    name
  end
  
  def name
    @filename
  end
  
  def name=(name)
    @filename = name
  end
  
  def find_layer(q)
    matches = []
    self.layers.each_with_index do |layer, index|
      matches.push(layer) if layer_name(layer) == q
    end
    matches
  end
  
  def layer_name(layer)
    return layer['Label'].nil? ? 'Layer' : layer['Label'].to_s
  end
  
  def layers
    @file
  end
  
  def export_layers
    layers.each_with_index do |layer, index|
      export_layer(layer)
    end
  end
  
  def export_layer(layer, *args)
    opts = {:format => 'png', :filename => layer_name(layer), :path => ""}
    args.each{|k,v| opts[k] = v}
    puts opts.inspect
    
    full_path = "#{opts[:path]}#{opts[:filename]}.#{opts[:format]}"
    layer.write(full_path)
  end

end