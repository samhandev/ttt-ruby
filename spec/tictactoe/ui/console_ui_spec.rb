require 'spec_helper'
require 'tictactoe/ui/console_ui'
require 'tictactoe/marker'

module TicTacToe
  module Ui
    describe ConsoleUi do
      let(:output) { StringIO.new }
      let(:marker) { Marker::X_MARKER }

      it "displays a given message to console" do
        input = StringIO.new
        ui = ConsoleUi.new(input, output)
        ui.display_message("test message")
        expect(output.string).to start_with("test message")
      end

      it "takes in user input, which represents a move" do
        input = StringIO.new("1\n")
        ui = ConsoleUi.new(input, output)
        user_input = ui.prompt_move_input(marker)
        expect(user_input).to eq(1)
      end

      it "returns false when an move input is not 0-8" do
        input = StringIO.new("a\n")
        ui = ConsoleUi.new(input, output)
        expect(ui.prompt_move_input(marker)).to be nil
      end

      it "asks the user to enter a move" do
        input = StringIO.new("1\n")
        ui = ConsoleUi.new(input, output)
        ui.prompt_move_input(marker)
        expect(output.string).to start_with("Player #{marker}, Please enter your next move: ")
      end

      it "keeps asking for the user to enter a move until it chooses a valid move" do
        input = StringIO.new("a\n1\n8\n")
        ui = ConsoleUi.new(input, output)
        board = Board.initial_board('XXXXXX---')
        expect(ui.prompt_for_move(board, marker)).to eq(7)
        expect(output.string).to include("Cannot make that move, try again.")
      end

      it "draws the board" do
        board = Board.new
        input = StringIO.new
        ui = ConsoleUi.new(input, output)
        ui.draw_board(board)
        expect(output.string).to include("  1  |  2  |  3  \n" +
                                         "-----+-----+-----\n" +
                                         "  4  |  5  |  6  \n" +
                                         "-----+-----+-----\n" +
                                         "  7  |  8  |  9  \n")
      end

      it "clears the screen" do
        input = StringIO.new
        ui = ConsoleUi.new(input, output)
        ui.clear_screen
        expect(output.string).to include("\u001b[2J" + "\u001b[H")
      end

      it "prompts for the game type until a valid input is entered" do
        input = StringIO.new("a\n5\n2\n")
        ui = ConsoleUi.new(input, output)

        expect(ui.prompt_game_type).to be(2)
        expect(output.string).to include("Enter the game type: ")
        expect(output.string).to include("Invalid game type.")
      end

      it "prompts to play again" do
        input = StringIO.new("a\n3\ny\n")
        ui = ConsoleUi.new(input, output)

        expect(ui.prompt_play_again?).to be true
        expect(output.string).to include("Do you want to play again?")
        expect(output.string).to include("Invalid input (y/n)")
      end

      it "returns false when the user enters n for the play again prompt" do
        input = StringIO.new("n\n")
        ui = ConsoleUi.new(input, output)

        expect(ui.prompt_play_again?).to be false
      end

      it "displays the goodbye messsage" do
        input = StringIO.new
        ui = ConsoleUi.new(input, output)
        ui.prompt_good_bye

        expect(output.string).to include("Goodbye and Thanks for playing!")
      end
    end
  end
end
