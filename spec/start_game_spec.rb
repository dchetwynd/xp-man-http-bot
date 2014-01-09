require 'rspec'
require_relative 'spec_app_loader'

describe 'Start game' do
  it 'should start the game successfully' do
    post '/Start', {:opponentName => 'OTHER', :pointsToWin => 100, :maxRounds => 200, :dynamiteCount => 100}
    expect(last_response.ok?).to be_true
  end
end
