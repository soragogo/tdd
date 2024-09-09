require_relative 'pong'
require 'minitest/autorun'
require 'minitest/reporters'
require 'mocha/minitest'

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
    
    def test_pong_has_ball
        assert_equal 8, @pong.ball_size
        assert_equal @pong.width/2, @pong.ball_x
        assert_equal @pong.height/2, @pong.ball_y
        assert 0.98 < @pong.ball_vec_x**2 + @pong.ball_vec_y**2
        assert 1.02 > @pong.ball_vec_x**2 + @pong.ball_vec_y**2
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

    def test_pong_inherits_from_gosu_window
        assert_equal true, @pong.is_a?(Gosu::Window)
    end

    def test_pong_calls_parent_constructor
        Gosu::Window.any_instance.expects(:initialize).with(800, 600, false).once
        Pong.new
    end

    def test_up_paddle_movement
        @pong.expects(:button_down?).with(Gosu::KB_W).returns(true)
        @pong.expects(:button_down?).with(Gosu::KB_S).returns(false)
        @pong.expects(:button_down?).with(Gosu::KB_UP).returns(true)
        @pong.expects(:button_down?).with(Gosu::KB_DOWN).returns(false)
        @pong.update
        assert_equal @pong.height / 2 - @pong.paddle_speed, @pong.paddle1_y
        assert_equal @pong.height / 2 - @pong.paddle_speed, @pong.paddle2_y
    end

    def test_down_paddle_movement
        @pong.expects(:button_down?).with(Gosu::KB_W).returns(false)
        @pong.expects(:button_down?).with(Gosu::KB_S).returns(true)
        @pong.expects(:button_down?).with(Gosu::KB_UP).returns(false)
        @pong.expects(:button_down?).with(Gosu::KB_DOWN).returns(true)
        @pong.update
        assert_equal @pong.height / 2 + @pong.paddle_speed, @pong.paddle1_y
        assert_equal @pong.height / 2 + @pong.paddle_speed, @pong.paddle2_y
    end

    def test_ball_movement
        @pong.update
        assert_equal @pong.width / 2 + @pong.ball_vec_x, @pong.ball_x
        assert_equal @pong.height / 2 + @pong.ball_vec_y, @pong.ball_y
    end

    def test_ball_bounce
        @pong.instance_variable_set(:@ball_y, 0)
        before_bounce = @pong.ball_vec_y
        @pong.update
        assert_equal -before_bounce, @pong.ball_vec_y
    end


    



end

