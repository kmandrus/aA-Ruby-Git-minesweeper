require 'colorize'

class Renderer

    def initialize(board)
        @board = board
    end

    def render(active_pos)
        system("clear")
        render_str = top_row_str
        @board.each_tile_with_pos do |tile, pos|
            row, col = pos
            if col == 0   
                render_str << row.to_s.ljust(row_header_width)
            end
            render_str << tile.render_value
            render_str << space
            if col == @board.size - 1
                render_str << new_line
            end
        end
        print render_str
    end

    def top_row_str
        top_row = "".ljust(row_header_width)
        (0...@board.size).each { |col_num| top_row << col_num.to_s.ljust(col_width) }
        top_row << new_line + "\n"
        top_row
    end

    def col_width
        3
    end
    def row_header_width
        5
    end
    def new_line
        "\n\n"
    end
    def space
        "  "
    end

end