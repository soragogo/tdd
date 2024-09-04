require_relative 'pong'
require 'minitest/autorun'
require 'minitest/reporters'

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

class TestPong < Minitest::Test
    def setup
        @pong = Pong.new
    end

    def test_pong_has_width_and_height
        assert_equal 800, @pong.width
        assert_equal 600, @pong.height
    end


    def test_pong_has_players
        assert_equal 0, @pong.player1_score
        assert_equal 0, @pong.player2_score
    end
    

    def test_pong_has_paddles
        assert_equal 10, @pong.paddle_width
        assert_equal 70, @pong.paddle_height
        assert_equal 10, @pong.paddle_speed
        assert_equal @pong.height/2, @pong.paddle1_y
        assert_equal @pong.height/2, @pong.paddle2_y
        assert_equal 0, @pong.paddle1_x
        assert_equal @pong.width - 10, @pong.paddle2_x
    end

end