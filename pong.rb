require 'gosu'

class Pong < Gosu::Window
    attr_reader :width, :height
    attr_reader :player1_score, :player2_score
    attr_reader :paddle_width, :paddle_height, :paddle_speed, :paddle1_y, :paddle2_y, :paddle1_x, :paddle2_x
    attr_reader :ball_x, :ball_y, :ball_vec_x, :ball_vec_y, :ball_size
    def initialize
        @width = 800
        @height = 600
        super(@width, @height, false)
        @player1_score = 0
        @player2_score = 0
        @paddle_width = 10
        @paddle_height = 70
        @paddle_speed = 10
        @paddle1_y = @height/2
        @paddle2_y = @height/2
        @paddle1_x = 0
        @paddle2_x = @width - 10
        @ball_size = 8
        reset_ball
    end
    def reset_ball
        @ball_x = @width/2
        @ball_y = @height/2
        a = rand(0.5..1.0)
        b = rand(-1.0..-0.5)
        @ball_vec_x = a**2 > b**2 ? a : b
        @ball_vec_y = rand(-1.0..1.0)
        length = Math.sqrt(@ball_vec_x**2 + @ball_vec_y**2)
        @ball_vec_x /= length
        @ball_vec_y /= length
    end

    def update
        if button_down?(Gosu::KB_W)
            puts "Gosu::KB_W pressed"
            @paddle1_y -= @paddle_speed
        end
        if button_down?(Gosu::KB_S)
        puts "Gosu::KB_S pressed"
        @paddle1_y += @paddle_speed
        end
        if button_down?(Gosu::KB_UP)
        puts "Gosu::KB_UP pressed"
        @paddle2_y -= @paddle_speed
        end
        if button_down?(Gosu::KB_DOWN)
        puts "Gosu::KB_DOWN pressed"
        @paddle2_y += @paddle_speed
        end

        @ball_x += @ball_vec_x
        @ball_y += @ball_vec_y

        if @ball_y < 0 or @ball_y > @height
            @ball_vec_y *= -1
        end
        # 仮にボールが左右の壁に当たった場合、ボールをリセットする
        if @ball_x < 0 or @ball_x > @width
            reset_ball
        end
    end


end

# Pong.new.show