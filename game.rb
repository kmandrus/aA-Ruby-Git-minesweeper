require_relative "board.rb"
require_relative "user_io.rb"
require_relative "renderer.rb"
require "yaml"

class Game

    attr_writer :board, :exit_program, :renderer

    def self.setup_game
        User_IO.welcome
        if User_IO.load_saved_game?
            file_path = User_IO.prompt_for_save_game_filename
            game = Game.load_game(file_path)
        else
            game = self.new_game
        end
        game
    end

    def self.load_game(file_path)
        file = File.open(file_path)
        yaml_board = file.read
        file.close
        board = YAML::load(yaml_board)
        game = Game.new()
        game.board = board
        game.exit_program = false
        game.renderer = Renderer.new(board)
        game
    end

    def self.new_game
        difficulty = User_IO.select_difficulty
        game = Game.new()
        board = Board.new(difficulty)
        game.board = board
        game.exit_program = false
        game.renderer = Renderer.new(board)
        game
    end

    @@valid_commands = [:flag, :reveal, :quit, :save]

    def initialize()
        @board = nil
        @exit_program = nil
        @renderer
    end

    def play
        until game_over?
            @renderer.render([0,0])
            cmd, args = get_user_cmd
            self.send(cmd, args)
        end

        if @board.bomb_revealed?
            @board.reveal_all_bombs
            @renderer.render([0,0])
            User_IO.bomb_revealed
        elsif @board.won?
            @renderer.render([0,0])
            User_IO.win_message
        end
    end

    def game_over?
        @board.bomb_revealed? || @board.won? || @exit_program
    end

    def get_user_cmd
        cmd, args = User_IO.enter_cmd
        until valid_input?(cmd, args)
            User_IO.invalid_input
            cmd, args = User_IO.enter_cmd
        end
        parse_input(cmd, args)
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
        file_path = User_IO.prompt_for_save_game_filename
        file = File.open(file_path, "w")
        file.print(@board.to_yaml)
        file.close
        User_IO.save_successful
    end

end

def run
    game = Game.setup_game
    game.play

    if User_IO.play_again?
        run
    end
end

if __FILE__ == $PROGRAM_NAME
    run
end