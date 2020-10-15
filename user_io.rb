class User_IO
    def self.bomb_revealed
        puts "You revealed a bomb!"
        puts "Game Over"
    end

    def self.invalid_input
        puts "invalid input"
        puts "please try again"
    end

    def self.enter_cmd_instructions
        puts
        puts "enter 'reveal' or 'flag' followed by the row and column"
        puts "for example: reveal 3 5, flag 0 2"
        puts "enter 'save' or 'quit' to save or quit the game" 
    end

    def self.save_successful
        system("clear")
        puts "save successful"
        sleep(2)
    end

    def self.prompt_for_save_game_filename
        puts "enter the filename of your save game"
        puts "ex: 'game_1.txt' or 'tough_level.txt'"
        gets.chomp
    end

    def self.enter_cmd
        self.enter_cmd_instructions
        cmd, *args = gets.chomp.split
        return [cmd, args]
    end

    def self.win_message
        puts "You win!"
    end

    def self.select_difficulty
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
            return self.select_difficulty
        end
    end

    def self.play_again?
        puts "Would you like to play again? (y/n)"
        input = gets.chomp
        return true if input == "y"
        false
    end

    def self.load_saved_game?
        puts "Do you want to load a saved game? (y/n)"
        input = gets.chomp
        return true if input == "y"
        false
    end

    def self.welcome
        system("clear")
        puts "Welcome to Minesweeper!\n"
    end

end