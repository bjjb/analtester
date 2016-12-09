# -*- encoding: utf-8 -*-
require 'pathname'
require 'fileutils'
require 'forwardable'
require 'erb'

# An Analtester has a directory, and can scan the directory for library files,
# creating corresponding test files for them. It also makes sure there's a
# test helper file (like test/), and a make file (like Rakefile).
class Analtester < Pathname
  VERSION = "0.0.3"

  include FileUtils
  include Comparable

  attr_accessor :verbose

  def initialize(framework = :minitest)
    super('.')
    send("initialize_#{framework}")
  end

  def <=>(another)
    Pathname.new(self).realpath <=> Pathname.new(another).realpath
  end

  def run
    make(runner, _runner)
    make(helper, _helper)
    tests.each { |test, template| make(test, template) }
  end

  def tests
    libs.map { |f| [@test.call(f), _test] }
  end

  def libs
    Dir[join(@_libs)].map { |f| join(f) }
  end

  def ext
    @_ext
  end

  def runner
    join(@_runner)
  end

  def _runner
    templates.join @__runner
  end

  def helper
    join @_helper
  end

  def _helper
    templates.join @__helper
  end

  def _test
    templates.join @_test
  end

  def templates
    Pathname.new(__FILE__).parent.parent.join('templates').join(@_templates)
  end

  def make(target, template)
    return if target.exist?
    @subject = classify(target)
    @library = library(target)
    target.parent.mkpath
    target.open('w') do |f|
      f << ERB.new(template.read).result(binding)
    end
  end

  def translate(s, x, y)
    s = "#$1#{y}#$2_#{y}#$3" if s.to_s =~ %r{^(.*/?)#{x}(/.*)(\.[^.]+)$}
    Pathname.new(s)
  end

  def library(s)
    s.to_s.split("#{@_type}/").last.split("_#{@_type}.rb").first
  end

  def classify(s)
    library(s).split('/').map { |x| camelize(x) }.join('::')
  end

  def camelize(s)
    s.split('_').map { |x| x.capitalize }.join('') 
  end

  def initialize_minitest
    @_type = 'test'
    @_runner = 'Rakefile'
    @_helper = 'test/test_helper.rb'
    @_templates = 'minitest'
    @__runner = 'Rakefile'
    @__helper = 'test_helper.rb'
    @_libs = "lib/**/*.rb"
    @test = lambda { |f| translate(f, 'lib', 'test') }
    @_test = 'test.rb'
  end

  def initialize_rspec
    @_type = 'spec'
    @_runner = 'Rakefile'
    @_helper = 'spec/spec_helper.rb'
    @_templates = 'rspec'
    @__runner = 'Rakefile'
    @__helper = 'spec_helper.rb'
    @_lib = 'lib'
    @_libs = "lib/**/*.rb"
    @test = lambda { |f| translate(f, 'lib', 'spec') }
    @_test = 'spec.rb'
  end

  def initialize_minispec
    @_type = 'spec'
    @_runner = 'Rakefile'
    @_helper = 'spec/spec_helper.rb'
    @_templates = 'minispec'
    @__runner = 'Rakefile'
    @__helper = 'spec_helper.rb'
    @_lib = 'lib'
    @_libs = "lib/**/*.rb"
    @test = lambda { |f| translate(f, 'lib', 'spec') }
    @_test = 'spec.rb'
  end
end
