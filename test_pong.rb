require_relative 'pong'
require 'minitest/autorun'
require 'minitest/reporters'
require 'mocha/minitest'

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

def test_paddle_min_max(paddle)
    setup
    @pong.instance_variable_set(paddle, -10)
    @pong.update
    assert_equal 0, @pong.instance_variable_get(paddle)

    @pong.instance_variable_set(paddle, @pong.height + 10)
    @pong.update
    assert_equal @pong.height - @pong.paddle_height, @pong.instance_variable_get(paddle)
end

class TestPong < Minitest::Test
    def setup
        @pong = Pong.new
    end

    def test_pong_has_width_and_height
        setup
        assert_equal 800, @pong.width
        assert_equal 600, @pong.height
    end


    def test_pong_has_players
        setup
        assert_equal 0, @pong.player1_score
        assert_equal 0, @pong.player2_score
    end

    def test_pong_has_ball
        setup
        assert_equal 10, @pong.ball_size
        assert_equal @pong.width/2, @pong.ball_x
        assert_equal @pong.height/2, @pong.ball_y
        assert 0.98 < @pong.ball_vec_x**2 + @pong.ball_vec_y**2
        assert 1.02 > @pong.ball_vec_x**2 + @pong.ball_vec_y**2
    end

    def test_pong_has_paddles
        setup
        assert_equal 10, @pong.paddle_width
        assert_equal 70, @pong.paddle_height
        assert_equal 10, @pong.paddle_speed
        assert_equal @pong.height/2, @pong.paddle1_y
        assert_equal @pong.height/2, @pong.paddle2_y
        assert_equal 0, @pong.paddle1_x
        assert_equal @pong.width - 10, @pong.paddle2_x
    end

    def test_pong_inherits_from_gosu_window
        setup
        assert_equal true, @pong.is_a?(Gosu::Window)
    end

    def test_pong_calls_parent_constructor
        setup
        Gosu::Window.any_instance.expects(:initialize).with(800, 600, false).once
        Pong.new
    end

    def test_up_paddle_movement
        setup
        @pong.expects(:button_down?).with(Gosu::KB_W).returns(true)
        @pong.expects(:button_down?).with(Gosu::KB_S).returns(false)
        @pong.expects(:button_down?).with(Gosu::KB_UP).returns(true)
        @pong.expects(:button_down?).with(Gosu::KB_DOWN).returns(false)
        @pong.expects(:button_down?).with(Gosu::KB_ESCAPE).returns(false)

        @pong.update
        assert_equal @pong.height / 2 - @pong.paddle_speed, @pong.paddle1_y
        assert_equal @pong.height / 2 - @pong.paddle_speed, @pong.paddle2_y
    end

    def test_down_paddle_movement
        setup
        @pong.expects(:button_down?).with(Gosu::KB_W).returns(false)
        @pong.expects(:button_down?).with(Gosu::KB_S).returns(true)
        @pong.expects(:button_down?).with(Gosu::KB_UP).returns(false)
        @pong.expects(:button_down?).with(Gosu::KB_DOWN).returns(true)
        @pong.expects(:button_down?).with(Gosu::KB_ESCAPE).returns(false)
        @pong.update
        assert_equal @pong.height / 2 + @pong.paddle_speed, @pong.paddle1_y
        assert_equal @pong.height / 2 + @pong.paddle_speed, @pong.paddle2_y
    end

    def test_ball_movement
        setup
        @pong.update
        assert_equal @pong.width / 2 + @pong.ball_vec_x*@pong.ball_speed, @pong.ball_x
        assert_equal @pong.height / 2 + @pong.ball_vec_y*@pong.ball_speed, @pong.ball_y
        assert_equal 5, @pong.ball_speed
    end

    def test_ball_bounce
        setup
        @pong.instance_variable_set(:@ball_y, 0)
        @pong.instance_variable_set(:@ball_vec_y,-0.21)
        before_bounce = @pong.ball_vec_y
        @pong.update
        assert_equal -before_bounce, @pong.ball_vec_y
    end

    def test_ball_reset
        setup
        @pong.instance_variable_set(:@ball_x, 0)
        @pong.instance_variable_set(:@ball_vec_x,-0.21)
        @pong.update
        assert_equal @pong.width / 2, @pong.ball_x
        assert_equal @pong.height / 2, @pong.ball_y
    end

    def test_score_increment
        setup
        @pong.instance_variable_set(:@ball_x, 0)
        @pong.instance_variable_set(:@ball_vec_x,-0.21)
        @pong.update
        assert_equal 1, @pong.player2_score

        @pong.instance_variable_set(:@ball_x, @pong.width)
        @pong.instance_variable_set(:@ball_vec_x,0.21)
        @pong.update
        assert_equal 1, @pong.player1_score
    end

    def test_paddle1_bounce
        setup
        ball_speed = @pong.ball_speed
        @pong.instance_variable_set(:@ball_x, 10)
        @pong.instance_variable_set(:@ball_y, @pong.paddle1_y + @pong.paddle_height/2)
        @pong.instance_variable_set(:@ball_vec_x, -0.21)
        @pong.update
        assert_equal 0.21, @pong.ball_vec_x
        assert_equal ball_speed + 1, @pong.ball_speed
    end

    def test_paddle2_bounce
        setup
        ball_speed = @pong.ball_speed
        @pong.instance_variable_set(:@ball_x, @pong.width - 10)
        @pong.instance_variable_set(:@ball_y, @pong.paddle2_y + @pong.paddle_height/2)
        @pong.instance_variable_set(:@ball_vec_x, 0.21)
        @pong.update
        assert_equal -0.21, @pong.ball_vec_x
        assert_equal ball_speed + 1, @pong.ball_speed
    end



    def test_paddle1_min_max
    test_paddle_min_max("@paddle1_y")
    end

    def test_paddle2_min_max
    test_paddle_min_max("@paddle2_y")
    end

    def test_font
        setup
        assert defined? @pong.font
    end


    def test_draw
        Gosu.expects(:draw_rect).with(@pong.paddle1_x, @pong.paddle1_y, @pong.paddle_width, @pong.paddle_height, Gosu::Color::WHITE).once
        Gosu.expects(:draw_rect).with(@pong.paddle2_x, @pong.paddle2_y, @pong.paddle_width, @pong.paddle_height, Gosu::Color::WHITE).once
        Gosu.expects(:draw_rect).with(@pong.width / 2, 0, 2, @pong.height, Gosu::Color::WHITE).once
        Gosu.expects(:draw_rect).with(@pong.ball_x, @pong.ball_y, @pong.ball_size, @pong.ball_size, Gosu::Color::WHITE).once
        @pong.font.expects(:draw_markup).with(@pong.player1_score, @pong.width / 2 - 50, 20, 0).once
        @pong.font.expects(:draw_markup).with(@pong.player2_score, @pong.width / 2 + 20, 20, 0).once

        @pong.draw
    end



end

