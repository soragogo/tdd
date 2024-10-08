require 'gosu'

class Pong < Gosu::Window
    attr_reader :width, :height
    attr_reader :player1_score, :player2_score
    attr_reader :paddle_width, :paddle_height, :paddle_speed, :paddle1_y, :paddle2_y, :paddle1_x, :paddle2_x
    attr_reader :ball_x, :ball_y, :ball_vec_x, :ball_vec_y, :ball_size, :ball_speed
    attr_reader :font
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
        @ball_size = 10
        @ball_speed = 5
        reset_ball
        @font = Gosu::Font.new(30)
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
        if @player1_score >= 10 or @player2_score >= 10
            if button_down?(Gosu::KB_C) && button_down?(Gosu::KB_LEFT_CONTROL)
                initialize
            end
            return
        end
        if button_down?(Gosu::KB_W)
            @paddle1_y -= @paddle_speed
        end
        if button_down?(Gosu::KB_S)
        @paddle1_y += @paddle_speed
        end
        if button_down?(Gosu::KB_UP)
        @paddle2_y -= @paddle_speed
        end
        if button_down?(Gosu::KB_DOWN)
        @paddle2_y += @paddle_speed
        end

        if button_down?(Gosu::KB_ESCAPE)
            close
        end

        if @paddle1_y < 0
            @paddle1_y = 0
        end
        if @paddle1_y > @height - @paddle_height
            @paddle1_y = @height - @paddle_height
        end

        if @paddle2_y < 0
            @paddle2_y = 0
        end
        if @paddle2_y > @height - @paddle_height
            @paddle2_y = @height - @paddle_height
        end

        @ball_x += @ball_vec_x * @ball_speed
        @ball_y += @ball_vec_y * @ball_speed

        if @ball_y <= 0 or @ball_y >= @height
            @ball_vec_y *= -1
        end
        # 仮にボールが左右の壁に当たった場合、ボールをリセットする
        if @ball_x <= 0 or @ball_x >= @width
            if @ball_x <= 0
                @player2_score += 1
            elsif @ball_x >= @width
                @player1_score += 1
            end
            reset_ball
        end

        # ボールがパドルに当たった場合、ボールを跳ね返す
        if (@ball_x <= @paddle_width and @ball_y.between?(@paddle1_y, @paddle1_y + @paddle_height))|| (@ball_x >= @width - @paddle_width and @ball_y.between?(@paddle2_y, @paddle2_y + @paddle_height))
            @ball_vec_x *= -1
            @ball_speed += 1
        end
    end



    def draw
        Gosu.draw_rect(@paddle1_x, @paddle1_y, @paddle_width, @paddle_height, Gosu::Color::WHITE)
        Gosu.draw_rect(@paddle2_x, @paddle2_y, @paddle_width, @paddle_height, Gosu::Color::WHITE)
        if @player1_score >= 10
            @font.draw_markup("Player1 Win!!!", @width/2 - 100, @height/2, 0, 1, 1, Gosu::Color::WHITE)
        elsif @player2_score >= 10
            @font.draw_markup("Player2 Win!!!", @width/2 - 100, @height/2, 0, 1, 1, Gosu::Color::WHITE)
        else
            Gosu.draw_rect(@width/2, 0, 2, @height, Gosu::Color::WHITE)
            Gosu.draw_rect(@ball_x, @ball_y, @ball_size, @ball_size, Gosu::Color::WHITE)
            @font.draw_markup(@player1_score, @width/2 - 50, 20, 0)
            @font.draw_markup(@player2_score, @width/2 + 20, 20, 0)
        end
    end


end

if __FILE__ == $PROGRAM_NAME
    Pong.new.show
end
