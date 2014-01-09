require 'rspec'
require_relative 'spec_app_loader'

describe 'Make a move' do
  it 'should play dynamite for as long as allowed' do
    post '/Start', {:dynamiteCount => 3}

    3.times do
      get '/Move'
      expect(last_response.body).to eq('DYNAMITE')
    end

    get '/Move'
    expect(last_response.body).not_to eq('DYNAMITE')
  end

  it 'should play a beating move if the opponent mostly plays the same move' do
    post '/Start', {:dynamiteCount => 3}

    5.times do
      post '/Move', {:lastOpponentMove => 'PAPER'}
      get '/Move'
    end

    expect(last_response.body).to eq('SCISSORS')
  end

  it 'should not play dynamite if opponent countered last few dynamites with waterbomb' do
    post '/Start', {:dynamiteCount => 5}

    3.times do
      get '/Move'
      post '/Move', {:lastOpponentMove => 'WATERBOMB'}
    end

    get '/Move'
    expect(last_response.body).not_to eq('DYNAMITE')
  end
end
