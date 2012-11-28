# -*- encoding: utf-8 -*-
require 'fileutils'

class Analtester
  include FileUtils
  def self.run
    new.run
  end

  def initialize(dir = nil)
    @dir = dir || Dir.pwd
  end

  def run
    ensure_test_helper
    tests.each { |test| ensure_test(test) }
  end

  def testfile(f)
    self.class.testfile(f)
  end

  def self.testfile(f)
    f.sub('lib/', 'test/').sub!(/\.rb/, '_test.rb')
  end

  def tests
    libraries.map { |f| testfile(f) }
  end

  def libraries
    Dir["#{@dir}/lib/**/*.rb"]
  end

  def ensure_test_helper
    ensure_test_directory
    print test_helper + " "
    if File.file?(test_helper)
      puts "✓"
    else
      make_test_helper!
      puts "Created"
    end
  end

  def ensure_test_directory
    print test_dir, " "
    if File.directory?(test_dir)
      puts "✓"
    else
      make_test_directory!
      puts "Created"
    end
  end

  def test_helper
    File.join(test_dir, "test_helper.rb")
  end

  def make_test_helper!
    File.open(test_helper, 'w') do |f|
      f.puts <<-RUBY
require 'minitest/autorun'
      RUBY
    end
  end

  def ensure_test(file)
    ensure_directory(File.dirname(file))
    print file, " "
    if File.file?(file)
      puts "✓"
    else
      make_test!(file)
      puts "Created"
    end
  end

  def ensure_directory(dir)
    print dir, " "
    if File.directory?(dir)
      puts "✓"
    else
      mkdir_p(dir)
      puts "Created"
    end
  end

  def class_name(file)
    # TODO - modules
    basename = File.basename(file, File.extname(file))
    basename.split('_').map { |s| s.chars.first.upcase + s.chars.to_a[1..-1].join }.join
  end

  def make_test!(file)
    File.open(file, 'w') do |f|
      f.puts <<-RUBY
require 'test_helper'

class #{class_name(file)} < MiniTest::Unit::TestCase
  def test_something
    flunk "Write me."
  end
end
      RUBY
    end
  end

  def make_test_directory!
    mkdir_p test_dir
  end

  def test_dir
    File.join(@dir, "test")
  end
end
