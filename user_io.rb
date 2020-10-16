require 'io/console'

class User_IO
    def self.bomb_revealed
        puts "You revealed a bomb!"
        puts "Game Over"
    end

    def self.instructions
        puts
        puts "use the arrow keys to move around the board"
        puts "press 'return' to reveal a tile or 'f' to flag a tile"
        puts "at any time, press 'esc' to quit or 's' to save the game" 
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

    def self.win_message(time_solved)
        puts "You win!"
        puts "Solution time: #{time_solved}"
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
    
    #Function snipped from https://gist.github.com/acook/4190379
    # Reads keypresses from the user including 2 and 3 escape character sequences.
    def self.read_key_press
        STDIN.echo = false
        STDIN.raw!
    
        input = STDIN.getc.chr
        if input == "\e" then
            input << STDIN.read_nonblock(3) rescue nil
            input << STDIN.read_nonblock(2) rescue nil
        end
        ensure
        STDIN.echo = true
        STDIN.cooked!
    
        return input
    end

end