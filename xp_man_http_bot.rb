require 'sinatra/base'

class XPManHTTPBot < Sinatra::Base
  enable :sessions

  post '/Start' do
    session[:dynamite_limit] = params[:dynamiteCount].to_i
    session[:opponent_move_count] = 0
    session[:times_dynamite_played] = 0
    session[:opponent_move_totals] = {'ROCK' => 0, 'PAPER' => 0, 'SCISSORS' => 0, 'DYNAMITE' => 0, 'WATERBOMB' => 0}
    session[:my_move_history] = []
    session[:opponent_move_history] = []
    'OK'
  end

  post '/Move' do
    session[:opponent_move_history] << params[:lastOpponentMove]
    session[:opponent_move_totals][params[:lastOpponentMove]] += 1
    session[:opponent_move_count] += 1
  end

  get '/Move' do
    if can_play_dynamite?
      if last_three_dynamite_moves_countered_with_waterbomb?
        move = random_move_without_dynamite
      else
        session[:times_dynamite_played] += 1
        move = 'DYNAMITE'
      end
    elsif opponent_mostly_plays_same_move?
      most_popular_opponent_move = get_most_popular_opponent_move
      beating_move = get_beating_move(most_popular_opponent_move)
      move = beating_move
    else
      move = random_move_without_dynamite
    end

    session[:my_move_history] << move
    move
  end

  private
  def can_play_dynamite?()
    session[:times_dynamite_played] < session[:dynamite_limit]
  end

  def get_last_three_dynamite_move_indexes
    session[:my_move_history].each_index.select {|index| session[:my_move_history][index] == 'DYNAMITE'}[-3..-1]
  end

  def opponent_played_waterbomb_on_move?(index)
    session[:opponent_move_history][index] == 'WATERBOMB'
  end

  def last_three_dynamite_moves_countered_with_waterbomb?
    if dynamite_played_by_myself_at_least_three_times?
      last_three_dynamite_move_indexes = get_last_three_dynamite_move_indexes
      opponent_dynamite_counters = last_three_dynamite_move_indexes.map {|index| session[:opponent_move_history][index]}
      last_three_dynamite_move_indexes.all? {|index| opponent_played_waterbomb_on_move?(index)}
    else
      false
    end
  end

  def dynamite_played_by_myself_at_least_three_times?
    session[:times_dynamite_played].to_i >= 3
  end

  def opponent_mostly_plays_same_move?()
    session[:opponent_move_totals].each_pair do |move_name, move_count|
      if (move_count.to_f / session[:opponent_move_count].to_f) >= 0.8
        return true
      end
    end

    false
  end

  def get_most_popular_opponent_move
    session[:opponent_move_totals].sort_by {|move_name, move_count| move_count.to_i}.last[0]
  end

  def get_beating_move(opponent_move)
    beating_moves = {'ROCK' => 'PAPER',
                     'PAPER' => 'SCISSORS',
                     'SCISSORS' => 'ROCK',
                     'DYNAMITE' => 'WATERBOMB',
                     'WATERBOMB' => 'ROCK'}
    beating_moves[opponent_move]
  end

  def random_move_without_dynamite()
    random_moves = ['ROCK', 'PAPER', 'SCISSORS', 'WATERBOMB']
    random_move_index = Random.rand(4)
    random_moves[random_move_index]
  end
end
