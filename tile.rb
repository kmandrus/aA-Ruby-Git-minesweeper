require 'colorize'

class Tile

    attr_accessor :num_adjacent_bombs, :bomb_exploded

    def initialize(has_bomb)
        @bomb = has_bomb
        @num_adjacent_bombs = nil
        @revealed = false
        @flagged = false
        @bomb_exploded = false
    end

    def has_bomb?
        @bomb
    end

    def flagged?
        @flagged
    end

    def place_flag
        @flagged = true unless revealed?
    end

    def remove_flag
        @flagged = false
    end

    def reveal
        @revealed = true
    end

    def revealed?
        @revealed
    end

    def bomb_exploded?
        return bomb_exploded
    end

    def render_value
        return "*".colorize(:black).on_red if bomb_exploded?
        return "F".colorize(:black).on_light_white if flagged? && !revealed?
        return " ".on_light_white unless revealed?
        return "*".colorize(:black).on_light_white if has_bomb?
        return " ".on_light_black if num_adjacent_bombs == 0
        return "1".colorize(:blue).on_light_black if num_adjacent_bombs == 1
        return "2".colorize(:green).on_light_black if num_adjacent_bombs == 2
        return "3".colorize(:red).on_light_black if num_adjacent_bombs >= 3

    end

end