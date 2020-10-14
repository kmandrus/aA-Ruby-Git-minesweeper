require_relative "board.rb"
require "yaml"

class Game

    attr_writer :board, :exit_program

    def self.prompt_new_or_saved_game
        system("clear")
        puts "Welcome to Minesweeper!\n"
        
        puts "Do you want to load a saved game? (y/n)"
        input = gets.chomp
        if input == "y"
            file_path = prompt_saved_game_name
            game = Game.load_game(file_path)
        else
            game = self.new_game
        end
        game.play
        
        if self.play_again?
            self.prompt_new_or_saved_game
        end
    end

    def self.prompt_saved_game_name
        puts "please enter the filename of your saved game"
        gets.chomp
    end

    def self.play_again?
        puts "Would you like to play again? (y/n)"
        input = gets.chomp
        return true if input == "y"
        false
    end

    def self.load_game(file_path)
        file = File.open(file_path)
        yaml_board = file.read
        file.close
        board = YAML::load(yaml_board)
        game = Game.new()
        game.board = board
        game.exit_program = false
        game
    end

    def self.new_game
        difficulty = self.user_selects_difficulty
        game = Game.new()
        game.board = Board.new(difficulty)
        game.exit_program = false
        game
    end

    def self.user_selects_difficulty
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
        else
            puts "invalid entry, please try again"
            return self.user_selects_difficulty
        end
    end

    @@valid_commands = [:flag, :reveal, :quit, :save]

    def initialize()
        @board = nil
        @exit_program = nil
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
    end

    def alert_bomb_revealed
        puts "You revealed a bomb!"
        puts "Game Over"
    end

    def alert_win
        puts "You win!"
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
        puts "for example: reveal 3 5, flag 0 2"
        puts "you can also 'save' or 'quit'" 
    end

    def parse_input(cmd, args)
        return [cmd.to_sym, args.map(&:to_i)]
    end

    def valid_input?(cmd, args)
        return false unless @@valid_commands.include?(cmd.to_sym)
        return true if cmd == "quit" || cmd == "save"
        
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

    def save(*args)
        file_path = prompt_for_save_game_file_path
        file = File.open(file_path, "w")
        file.print(@board.to_yaml)
        file.close
        alert_save_successful
    end

    def alert_save_successful
        system("clear")
        puts "save successful"
        sleep(2)
    end

    def prompt_for_save_game_file_path
        puts "enter the file name of your save game with no spaces"
        puts "ex: game_1.txt or tough_level.txt"
        gets.chomp
    end

end

if __FILE__ == $PROGRAM_NAME
    Game.prompt_new_or_saved_game
end