require "pry"

class TicTacToe

  attr_accessor :visual_board, :turn_num, :hidden_board, :selected_num

  #######################
  ## initalize methods ##
  #######################

  def initialize
    @visual_board = make_board
    @hidden_board = Array.new(3) { Array.new(3, 0) }
    @turn_num = 1
    @selected_num = "no space selected yet"
  end

  def make_board
    board = []
    row = []
    i = 1
    while i < 10
      row << i.to_s
      if i % 3 == 0
        board << row
        row = []
      end
      i += 1
    end
    board
  end

  ################
  ## controller ##
  ################

  def play
    decide_player
    self.turn_num += 1
  end

  def main
    puts "Let's play Tic-Tac-Toe!"
    while self.turn_num < 5
      play
    end
    while 5 <= self.turn_num && self.turn_num < 10
      play
      check_for_winner
    end
  end

  def print_board
    print "\n"
    visual_board.each_with_index do |row, index| 
      row.each_with_index do |space, i|
        if i != 1
          print " #{space} "
        else 
          print "| #{space} |"
        end
      end
      print "\n"
      if index < 2
        puts "-----------"
      end
    end
    print "\n"
  end

  ##################################
  ## shared b/t user and computer ##
  ##################################

  def user_turn?
    turn_num % 2 == 0 ? false : true
  end

  def get_placeholder
    user_turn? ? "X" : "O"
  end

  def decide_player
    user_turn? ? user_turn : computer_turn
  end

  ###############
  ## user turn ##
  ###############

  def user_turn
    print_board
    print "Enter number of where you would like to play: "
    self.selected_num = gets.chomp.strip
    update_board
  end

  def get_user_position
    visual_board.each do |row|
      if row.include?(selected_num)
        return position = [visual_board.index(row), row.index(selected_num)]
      end
    end
  end

  def update_board
    row, column = get_user_position
    visual_board[row][column] = get_placeholder
    hidden_board[row][column] = 1
  end

  def get_placeholder
    placeholder = "O"
    if turn_num % 2 == 0
      placeholder = "X"
    end
    placeholder
  end

  ###################
  ## computer turn ##
  ###################

  def computer_turn
    puts "computer takes turn"
  end

  ######################
  ## check for winner ##
  ######################

  def check_for_winner
    if diagonal_winner? || horizontal_winner? || vertical_winner?
      binding.pry
      print_board
      message = "Congratuations! You"
      if user_turn?
        message = "I"
      end
      puts "#{message} won." 
      self.turn_num = 100
    end
  end

  def diagonal_winner?
    middle = hidden_board[1][1]
    if hidden_board[0][0] + middle + hidden_board[2][2] == 3 || hidden_board[0][2] + middle + hidden_board[2][0] == 3
      return true
    end
  end

  def horizontal_winner?
    row = 0
    while row < 3
      if hidden_board[row][0] + hidden_board[row][1] + hidden_board[row][2] == 3
        return true
      end
      row += 1
    end
  end

  def vertical_winner?
    column = 0
    while column < 3
      if hidden_board[0][column] + hidden_board[1][column] + hidden_board[2][column] == 3
        return true
      end
      column += 1
    end
  end
end

game = TicTacToe.new
game.main