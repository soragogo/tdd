require_relative 'pong'
require 'minitest/autorun'

class TestPong < Minitest::Test
    def setup
        @pong = Pong.new
    end

    def test_pong_has_width_and_height
        assert_equal 800, @pong.width
        assert_equal 600, @pong.height
    end


    

end