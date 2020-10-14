require_relative "board.rb"

class Game

    @@valid_commands = [:flag, :reveal, :quit]

    def initialize(difficulty)
        @board_size = difficulty
        @board = Board.new(@board_size)
        @exit_program = false
    end

    def play

        until game_over?
            @board.render
            cmd, args = user_input
            self.send(cmd, args)
        end

        if @board.bomb_revealed?
            @board.reveal_all_bombs
            @board.render
            alert_bomb_revealed
        elsif @board.won?
            @board.render
            alert_win
        end

        play_again?
    end

    def alert_bomb_revealed
        puts "You revealed a bomb!"
        puts "Game Over"
    end

    def alert_win
        puts "You win!"
    end

    def play_again?
        puts "Would you like to play again? (y/n)"
        input = gets.chomp
        return true if input == "y"
        false
    end

    def game_over?
        @board.bomb_revealed? || @board.won? || @exit_program
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
        puts "for example: reveal 3 5, flag 0 2, or quit"
    end

    def parse_input(cmd, args)
        return [cmd.to_sym, args.map(&:to_i)]
    end

    def valid_input?(cmd, args)
        return false unless @@valid_commands.include?(cmd.to_sym)
        return true if cmd == "quit"
        
        digits = (0...@board.size).to_a.map(&:to_s)
        
        unless Array.try_convert(args) &&
            args.size == 2 &&
            args.all? { |arg| digits.include?(arg) }
            
            return false
        end

        true
    end

    def flag(pos)
        if @board.flagged?(pos)
            @board.remove_flag(pos)
        else
            @board.place_flag(pos)
        end
    end

    def reveal(pos)
        @board.reveal(pos)
    end

    def quit(*args)
        @exit_program = true
    end

end

def user_selects_difficulty
    puts "please choose your difficulty:"
    puts "enter 'e' for easy, 'm' for medium, or 'h' for hard"
    input = gets.chomp

    case input
    when "e"
        return 5
    when "m"
        return 8
    when "h"
        return 12
    when "quit"
        return nil
    else
        puts "invalid entry, try again or enter 'quit' to exit the program"
        user_selects_difficulty
    end
end

def new_game
    system("clear")
    puts "Welcome to Minesweeper\n"
    difficulty = user_selects_difficulty
    if difficulty
        game = Game.new(difficulty)
        play_again = game.play
    end
    if play_again
        new_game
    end
end


if __FILE__ == $PROGRAM_NAME
    new_game
end