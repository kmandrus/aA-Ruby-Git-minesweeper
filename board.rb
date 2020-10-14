require_relative "tile.rb"
require "byebug"

class Board

    attr_reader :size 

    def initialize(size)
        @size = size
        @grid = make_grid(size, size)
        @bomb_revealed = false
        
    end

    def render
        system("clear")
        render_str = top_row_str
        @grid.each_with_index do |row, row_num|
            render_str << row_num.to_s + space + space
            row.each do |tile|
                render_str << tile.render_value + space
            end
            render_str << new_line
        end
        print render_str
    end

    def top_row_str
        top_row = "     "
        (0...@size).each { |col_num| top_row << col_num.to_s + space }
        top_row << new_line + "\n"
        top_row
    end

    def debug_render
        system("clear")
        render_str = top_row_str

        @grid.each_with_index do |row, row_num|
            render_str << row_num.to_s + space + space
            row.each do |tile|
                if tile.has_bomb?
                    render_str << "*" + space
                else
                    render_str << tile.num_adjacent_bombs.to_s + space
                end
            end
            render_str << new_line 
        end
        
        print render_str
    end

    def new_line
        "\n\n"
    end

    def space
        "  "
    end

    def make_grid(width, num_bombs)
        tile_stack = []
        num_empty_tiles = width ** 2 - num_bombs

        num_bombs.times do
            tile_stack << Tile.new(true)
        end
        num_empty_tiles.times do
            tile_stack << Tile.new(false)
        end
        tile_stack.shuffle!
        grid = Array.new(width) { [] }
        grid.each do |row|
            width.times { row << tile_stack.pop }
        end

        grid.each_with_index do |row, row_num|
            row.each_with_index do |tile, col_num|
                pos = [row_num, col_num]
                tile.num_adjacent_bombs = num_adj_bombs(pos, grid)
            end
        end

        grid

    end

    def num_adj_bombs(pos, grid=@grid)
        bomb_count = 0
        adj_tiles(pos, grid).each do |tile|
            bomb_count += 1 if tile.has_bomb?
        end
        bomb_count
    end

    def adj_positions(center_pos, grid=@grid)
        positions = []
        center_row, center_col = center_pos
        start_row = center_row - 1
        start_col = center_col - 1

        (start_col..start_col + 2).each do |col_num|
            (start_row..start_row + 2).each do |row_num|
                pos = [row_num, col_num]
                if valid_pos?(pos) && (center_pos != pos)
                    positions << pos
                end
            end
        end
       
        positions
    end

    def adj_tiles(center_pos, grid=@grid)
        adj_positions(center_pos, grid).map do |pos|
            row, col = pos
            grid[row][col]
        end
    end

    def valid_pos?(pos)
        row, col = pos
        if row >= 0 && row < @size &&
            col >= 0 && col < @size

            return true
        end
        false
    end

    def place_flag(pos)
        self[pos].place_flag
    end

    def remove_flag(pos)
        self[pos].remove_flag
    end

    def reveal(pos)
        tile = self[pos]
        unless tile.revealed?
            tile.reveal
            if tile.has_bomb?
                @bomb_revealed = true
            elsif tile.num_adjacent_bombs == 0
                adj_positions(pos).each { |adj_pos| reveal(adj_pos) }
            end
        end
    end

    def flagged?(pos)
        self[pos].flagged?
    end

    def [](pos)
        row, col = pos
        @grid[row][col]
    end

    def bomb_revealed?
        @bomb_revealed
    end

end