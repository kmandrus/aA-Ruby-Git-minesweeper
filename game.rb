require_relative "board.rb"

class Game

    def initialize()
        @board = Board.new(8)
    end

    def play

        until game_over?
            @board.render
            cmd, *args = user_input
        end
        
    end

    def game_over?
        return false
    end

    def user_input
        alert_enter_cmd
        cmd, *args = gets.chomp.split
        until valid_input?(cmd, args)
            alert_invalid_input
            cmd, *args = gets.chomp.split
        end
        parse_input(cmd, args)
    end

    def alert_invalid_input
        puts "invalid input"
        puts "please try again"
    end

    def alert_enter_cmd
        puts
        puts "please enter 'reveal' or 'flag' followed by the row and column"
        puts "for example: reveal 3 5"
    end

    def parse_input(cmd, args)
        return [cmd.to_sym, args.map(&:to_i)]
    end

    def valid_input?(cmd, args)
        digits = (0...@board.size).to_a.map(&:to_s)
        
        unless (cmd == "flag" || cmd == "reveal") &&
            Array.try_convert(args) &&
            args.size == 2 &&
            digits.include?(args.first) &&
            digits.include?(args.last)
            
            return false
        end

        true
    end

end

if __FILE__ == $PROGRAM_NAME
    game = Game.new
    game.play
end