require_relative "tile.rb"
require "byebug"

class Board

    attr_reader :size 

    def initialize(size)
        @size = size
        @grid = make_grid(size, size)
        
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
        adj_bombs = 0
        adj_tiles(pos, grid).each do |tile|
            adj_bombs += 1 if tile.has_bomb?
        end
        adj_bombs
    end

    def adj_tiles(center_pos, grid=@grid)
        center_row, center_col = center_pos
        start_row = center_row - 1
        start_col = center_col - 1
        
        adj = []
        (start_col..start_col + 2).each do |col_num|
            (start_row..start_row + 2).each do |row_num|
                
                pos = [row_num, col_num]
                if valid_pos?(pos) && (center_pos != pos)
                    adj << grid[row_num][col_num]
                end

            end
        end
        
        adj
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
        row, col = pos
        grid[row][col].place_flag
    end

    def remove_unflag(pos)
        row, col = pos
        grid[row][col].remove_flag
    end

    def reveal(pos)
        grid[row][col].reveal
    end



end