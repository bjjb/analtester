require 'test_helper'
require 'pathname'
require 'tmpdir'
require 'fileutils'

class AnaltesterTest < Minitest::Test
  include FileUtils

  def setup
    @home = pwd
    dir = Dir.mktmpdir
    Dir.chdir(dir)
    @dir = Pathname.new(dir).realpath
    touchfiles('lib/foo.rb', 'lib/foo/bar.rb')
    @dir.join("lib/foo.rb").open('w') do |f|
      f.write <<-EOF
module Foo
  VERSION = "0.0.1"
end
      EOF
    end
    @dir.join('lib/foo/bar.rb').open('w') do |f|
      f.write <<-EOF
module Foo
  class Bar
    def hello
      puts "Hello!"
    end
  end
end
      EOF
    end
  end

  def teardown
    Dir.chdir(@home)
    rm_rf @dir
  end

  def test_initialization_with_a_block
    analtester = Analtester.new do |a|
      assert_respond_to(a, :tests)
      assert_kind_of(Analtester, a)
    end
  end

  def test_minitest
    Analtester.new.run
    assert @dir.join("Rakefile").exist?
    assert @dir.join("test/test_helper.rb").exist?
    assert @dir.join("test/foo_test.rb").exist?
    t = @dir.join("test/foo/bar_test.rb")
    assert t.exist?
    assert_match %r{require ['"]foo/bar["']}, t.read
    assert_match %r{class Foo::BarTest}, t.read
    out, err = capture_subprocess_io { system("rake") }
    assert_empty err
    assert_match %r{2 runs}, out
    assert_match %r{2 skips}, out
  end

  def test_minispec
    touchfiles('lib/foo.rb', 'lib/foo/bar.rb')
    Analtester.new(:minispec).run
    assert @dir.join("Rakefile").exist?
    assert @dir.join("spec/spec_helper.rb").exist?
    assert @dir.join("spec/foo_spec.rb").exist?
    t = @dir.join("spec/foo/bar_spec.rb")
    assert t.exist?
    assert_match %r{require ['"]foo/bar["']}, t.read
    assert_match %r{describe Foo::Bar}, t.read
    out, err = capture_subprocess_io { system("rake") }
    assert_empty err
    assert_match %r{2 runs}, out
    assert_match %r{2 skips}, out
  end

  def test_rspec
    touchfiles('lib/foo.rb', 'lib/foo/bar.rb')
    Analtester.new(:rspec).run
    assert @dir.join("Rakefile").exist?
    assert @dir.join("spec/spec_helper.rb").exist?
    assert @dir.join("spec/foo_spec.rb").exist?
    t = @dir.join("spec/foo/bar_spec.rb")
    assert t.exist?
    assert_match %r{require ['"]foo/bar["']}, t.read
    assert_match %r{describe Foo::Bar}, t.read
    out, err = capture_subprocess_io { system("rake") }
    assert_empty err
    assert_match %r{2 examples}, out
    assert_match %r{2 pending}, out
  end

private
  def touchfiles(*files)
    files.each do |f|
      @dir.join(f).parent.mkpath
      touch @dir.join(f)
    end
  end
end
