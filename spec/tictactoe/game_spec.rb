require 'spec_helper'
require 'tictactoe/game'

module TicTacToe
  describe Game do
    let(:player_1) { PlayerSpy.new }
    let(:player_2) { PlayerSpy.new }
    let(:players) { [player_1, player_2] }
    let(:ui) { UiSpy.new }

    it "is running when you have a new game" do
      board = Board.new
      game = Game.new(board, players)
      expect(game.running?).to be true
    end
    
    it "is not running when the board is full" do
      board = Board.new('XXXOOOXXX')
      game = Game.new(board, players)
      expect(game.running?).to be false
    end

    it "update will make a move on the board" do
      board = Board.new
      game = Game.new(board, players)
      game.update
      expect(game.running?).to be true
    end

    it "sets up 2 player and expect player 1 to make a move after one update" do
      board = Board.new
      game = Game.new(board, players)
      game.update

      expect(player_1.next_move_times_called).to eq(1)
      expect(player_2.next_move_times_called).to eq(0)
    end

    it "changes the player between each move" do
      board = Board.new
      game = Game.new(board, players)
      game.update
      game.update
      game.update

      expect(player_1.next_move_times_called).to eq(2)
      expect(player_2.next_move_times_called).to eq(1)
    end

    it "draws the board" do
      board = Board.new
      game = Game.new(board, players, ui)

      game.draw
      expect(ui.clear_screen_times_called).to eq(1)
      expect(ui.draw_board_times_called).to eq(1)
    end

    it "displays the game over message if the game is no longer running" do
      board = Board.new('XXXOOOXXX')
      game = Game.new(board, players, ui)
      
      game.draw
      expect(ui.display_message_times_called).to eq(1)
    end
  end

  class PlayerSpy
    attr_reader :next_move_times_called, :marker

    def initialize
      @marker = 'X'
      @next_move_times_called = 0
    end

    def next_move(board)
      @next_move_times_called += 1
    end
  end

  class UiSpy
    attr_reader :draw_board_times_called, :clear_screen_times_called, :display_message_times_called

    def initialize
      @draw_board_times_called = 0
      @clear_screen_times_called = 0
      @display_message_times_called = 0
    end

    def draw_board(board)
      @draw_board_times_called += 1
    end

    def clear_screen
      @clear_screen_times_called += 1
    end

    def display_message(message)
      @display_message_times_called += 1
    end
  end
end