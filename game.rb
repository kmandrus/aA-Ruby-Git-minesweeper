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
        @selected_pos = [0,0]
    end

    def play
        until game_over?
            @renderer.render(@selected_pos)
            User_IO.instructions
            cmd = User_IO.read_key_press
            until valid_cmd?(cmd)
                cmd = User_IO.read_key_press
            end
            execute_cmd(cmd)
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

    def valid_cmd?(cmd)
        cmds = ["\r", "\e", "\e[A", "\e[B", "\e[C", "\e[D", "\u0003", "f", "s"]
        cmds.include?(cmd)
    end

    def execute_cmd(cmd)  
        row, col = @selected_pos
        
        case cmd
        when "\r" #RETURN
            reveal(@selected_pos)
        when "\e" #ESCAPE
            quit
        when "s"
            save
        when "\e[A" #UP ARROW
            new_pos = [row - 1, col]
            @selected_pos = new_pos if @board.valid_pos?(new_pos)
        when "\e[B" #DOWN ARROW
            new_pos = [row + 1, col]
            @selected_pos = new_pos if @board.valid_pos?(new_pos)
        when "\e[C" #RIGHT ARROW
            new_pos = [row, col + 1]
            @selected_pos = new_pos if @board.valid_pos?(new_pos)
        when "\e[D" #LEFT ARROW
            new_pos = [row, col - 1]
            @selected_pos = new_pos if @board.valid_pos?(new_pos)
        when "\u0003" #CONTROL C
            exit 0
        when "f" #f KEY
            flag(@selected_pos)
        end
    end

    def game_over?
        @board.bomb_revealed? || @board.won? || @exit_program
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

    def quit
        @exit_program = true
    end

    def save
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