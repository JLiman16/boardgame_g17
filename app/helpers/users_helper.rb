module UsersHelper
    def sortable(title, column)
        direction = column == params[:sort] && params[:direction] == "asc" ? "desc" : "asc"
        link_to title, find_game_path(@user, :sort => column, :direction => direction)
    end
end
