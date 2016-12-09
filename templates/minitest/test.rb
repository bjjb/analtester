require 'test_helper'
require '<%= @library %>'

class <%= @subject %>Test < Minitest::Test
  def setup
    # Set me up
  end

  def teardown
    # Tear me down
  end

  def test_something
    skip "Write some tests!"
  end
end
