require 'test_helper'
require 'tmpdir'
require 'fileutils'

class AnaltesterTest < MiniTest::Unit::TestCase
  include FileUtils

  def setup
    @home = pwd
    @test_directory = Dir.mktmpdir
    Dir.chdir(@test_directory)
  end

  def test_creation_of_tests
    mkdir_p 'lib/foo/bar'
    touch %w(lib/foo.rb lib/foo/bar.rb lib/foo/bar/baz.rb)
    Analtester.new(@test_directory).run
    assert File.exists?('test/foo/bar/baz_test.rb')
    assert File.exists?('test/foo/bar_test.rb')
    assert File.exists?('test/foo_test.rb')
  end

  def teardown
    Dir.chdir(@home)
    rm_rf @test_directory
  end
end
