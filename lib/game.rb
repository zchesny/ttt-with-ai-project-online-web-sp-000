require 'pry'

class Game

  attr_accessor :board, :player_1, :player_2

  WIN_COMBINATIONS = [
    [0,1,2],
    [3,4,5],
    [6,7,8],
    [0,3,6],
    [1,4,7],
    [2,5,8],
    [0,4,8],
    [6,4,2]
  ]

  def initialize(player_1 = Players::Human.new("X"), player_2 = Players::Human.new("O"), board = Board.new)
    self.player_1 = player_1
    self.player_2 = player_2
    self.board = board
  end

  def current_player
    self.board.turn_count % 2 == 0 ? player_1 : player_2
  end

  def won?
    WIN_COMBINATIONS.detect do |combo|
      self.board.cells[combo[0]] == self.board.cells[combo[1]] &&
      self.board.cells[combo[1]] == self.board.cells[combo[2]] &&
      self.board.taken?(combo[0] + 1)
    end
  end

  def draw?
    self.board.full? && !self.won?
  end

  def over?
    self.draw? || self.won?
  end

  def winner
    if winning_combo = self.won?
      self.board.cells[winning_combo.first]
    end
  end

  def turn
    puts "Please enter 1-9:"
    input = self.current_player.move(board)
    if self.board.valid_move?(input)
      self.board.update(input, self.current_player)
      self.board.display
    else
      puts "Invalid move"
      self.turn
    end
  end

  def play
    turn until over?
    if self.draw?
      puts "Cat's Game!"
    elsif self.won? != nil
      puts "Congratulations #{winner}!"
    end
  end

  def self.start
    puts "Welcome to Tic Tac Toe!"
    puts "What kind of game would you like to play?"
    puts "Enter 0 for 0 players"
    puts "Enter 1 for 1 player"
    puts "Enter 2 for 2 players"
    puts "To quit, type 'exit'"
    type = gets.strip
    case type
      # FIXME: create "wargames type"
      # https://learn.co/tracks/full-stack-web-development-v8/module-6-object-oriented-ruby/section-17-final-projects/tic-tac-toe-with-ai
    when "0"
      Game.new(Players::Computer.new("X"), Players::Computer.new("O"), board = Board.new).play
    when "1"
      puts "Enter 'X' to go first. (Computer will go second)"
      puts "Enter 'O' to go second. (Computer will go first)"
      token = gets.strip.upcase
      case token
      when "X"
        Game.new(Players::Human.new("X"), Players::Computer.new("O"), board = Board.new).play
      when "O"
        Game.new(Players::Computer.new("X"), Players::Human.new("O"), board = Board.new).play
      else
        puts "Sorry, invalid input"
      end
    when "2"
      Game.new.play
    when "exit"
      return
    end
    Game.start
  end





end
