class Tile

    attr_accessor :num_adjacent_bombs

    def initialize(has_bomb)
        @bomb = has_bomb
        @num_adjacent_bombs = nil
        @revealed = false
        @flagged = false
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

    def render_value
        return "F" if flagged? && !revealed?
        return "_" unless revealed?
        return "*" if has_bomb?
        return num_adjacent_bombs.to_s
    end

end