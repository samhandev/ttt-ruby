require 'spec_helper'
require 'tictactoe/game_loop'

module TicTacToe
  class TestGame
    attr_reader :updated, :update_count, :draw_count
    attr_accessor :running
    
    def initialize
      @updated = false
      @running = [false]
      @update_count = 0
      @draw_count = 0
    end

    def update
      @updated = true
      @update_count += 1
    end

    def running?
      @running.shift
    end

    def draw
      raise 'Invalid draw' if (draw_count != (update_count - 1))
      @draw_count += 1
    end
  end

  describe GameLoop do
    let(:game) { TestGame.new }
    let(:game_loop) { GameLoop.new(game) }

    def set_up_times_game_is_running(game, number_of_loops)
      running_loops = [false]
      number_of_loops.times { running_loops.unshift(true) }
      game.running = running_loops
    end

    it "does nothing when the game is stopped" do
      game_loop.run
      expect(game.updated).to be false
    end

    it "updates the game once before the game is stopped" do
      set_up_times_game_is_running(game, 1)
      game_loop.run
      expect(game.updated).to be true
    end


    it "updates until the game is stopped" do
      set_up_times_game_is_running(game, 2)
      game_loop.run
      expect(game.updated).to be true
      expect(game.update_count).to eq(2)
    end

    it "draws after the update" do
      set_up_times_game_is_running(game, 1)
      game_loop.run
      expect(game.draw_count).to eq(1)
    end
  end
end
