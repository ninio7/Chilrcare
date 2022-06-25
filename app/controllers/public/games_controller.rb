class Public::GamesController < ApplicationController
  def index
    case params[:sort_games]
    when "old"
      @games = Game.page(params[:page])
    when "lot_favorite"
       @games = Game.all.page(params[:page]).favorite
    when "few_favorite"
      @games = Game.all.page(params[:page]).favorite.reverse
    else # default(new)
      @games = Game.latest.page(params[:page])
    end
    @sort_games = params[:sort_games]
    @games_all_count= Game.all.count
    @game = Game.new
    @pages = Game.all.order(created_at: :desc).page(params[:page])
    @tag_list = Tag.all
  end

  def show
    @game = Game.find(params[:id])
    @game_tags = @game.tags
    @tag_list = Tag.all
  end

  def search_tag
    @tag_lists = Tag.all
    if params[:tag_id].present?
      @tag = Tag.find(params[:tag_id])
      @tags = Tag.where('name LIKE ?', "%#{params[:name]}%")
      @games = @tag.games.order(created_at: :desc).page(params[:page])
      @tag_name=params[:name]
    elsif params[:title].present?
      @games = Game.where('title LIKE ?', "%#{params[:title]}%").page(params[:page])
      @game_title=params[:title]
      @games_all_count=Game.where("title LIKE ?","%#{@game_title}%").count
    else
      # @games = Game.none
    end
    @sort_games = params[:sort_games]
    @gamse = Game.all
  end

  private

  def game_params
    params.require(:game).permit(:title, :body)
  end

end

