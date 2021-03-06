require 'tempfile'

# TODO: do some pre-comparison on a and b so we can skip creating temp files and all that jazz.
# NOTE: this is so ghetto ;)

module Diffable
  def diff(b, options = {})
    Diff.new(self, b, options).diff
  end
end

class Diff  
  attr_reader :output, :changed
  alias_method :changed?, :changed
  
  def initialize(a, b, options = {})
    @a = a
    @b = b
    @options = options
    @changed = false
    @output = ''
  end

  def diff
    file_a = string_to_file('a', @a).path
    file_b = string_to_file('b', @b).path
    @output = format_output(`diff --unified=-1 #{file_a} #{file_b}`)
    @changed = !@output.strip.empty?
    self
  end
  
  def to_html(options = {})
    diff.output.each_line.inject("") do |output, line|
      output + \
        case line[0]
        when '@'
          "<div class='#{options[:meta_class] || 'diff_meta'}'>#{line}</div>"
        when '-'
          "<div class='#{options[:sub_class] || 'diff_sub'}'>#{line}</div>"
        when '+'
          "<div class='#{options[:add_class] || 'diff_add'}'>#{line}</div>"
        else
          line
        end
    end
  end

  def to_s
    output
  end
    
private  

  def string_to_file(key, data)
    Tempfile.open("#{key}.tmp_diff") do |file|
      file << data.to_str
    end
  end

  def format_output(output)
    output.gsub! /\-{3}.+/, "--- #{@options[:mine]}" if @options[:mine]
    output.gsub! /\+{3}.+/, "+++ #{@options[:theirs]}" if @options[:theirs]
    output
  end
end

class String
  include Diffable
end

if __FILE__ == $0

  test1 = <<-T1
  hello
  world
  this is my original file
  T1

  test2 = <<-T2
  hello
  world
  whatsup world?

  T2

  d = test1.diff(test2, :mine => "Version 1\t#{Time.now}", :theirs => "Version 2\t#{Time.now}")
  puts d.changed?
  puts d.to_html
  
end