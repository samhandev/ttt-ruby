module TicTacToe
  module Mock
    class Game
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
  end
end