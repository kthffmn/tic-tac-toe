require "pry"

class TicTacToe

  attr_accessor :visual_board, :turn_num, :hidden_board

  #######################
  ## initalize methods ##
  #######################

  def initialize
    @visual_board = make_board
    @hidden_board = Array.new(3) { Array.new(3, 0) }
    @turn_num = 1
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

  def main
    puts "Let's play Tic-Tac-Toe!"
    print_board
    while self.turn_num < 5
      update_board
      self.turn_num += 1
    end
    while 5 <= self.turn_num && self.turn_num < 10
      update_board
      check_for_winner
      self.turn_num += 1
      if turn_num == 10
        puts "Tie game."
        print "\n"
        break
      end
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

  ###############
  ## reference ##
  ###############

  def user_turn?
    turn_num % 2 == 0 ? false : true
  end

  def placeholder
    user_turn? ? "O" : "X"
  end

  def number
    user_turn? ? 1 : -1
  end

  ##################
  ## update board ##
  ##################

  def update_board
    if user_turn?
      row, column = users_turn
    else 
      row, column = computers_turn
    end
    visual_board[row][column] = placeholder
    hidden_board[row][column] = number
    print_board
  end

  def users_turn
    print "Enter number: "
    selected_num = gets.chomp.strip
    visual_board.each do |row|
      if row.include?(selected_num)
        return [visual_board.index(row), row.index(selected_num)]
      end
    end
    print "Please enter a valid number. "
    users_turn
  end

  # def computers_turn
  #   puts "Here's my move:"
  #   row = rand(0..2)
  #   column = rand(0..2)
  #   while hidden_board[row][column] == 1 || hidden_board[row][column] == -1
  #     row = rand(0..2)
  #     column = rand(0..2)
  #   end
  #   return [row, column]
  # end

  def computers_turn
    puts "Here's my move:"
    try_to_win
    be_defensive
    optimize_location
  end

  ######################
  ## check for winner ##
  ######################

  def check_for_winner
    if diagonal_winner? || horizontal_winner? || vertical_winner?
      message = "I"
      if user_turn?
        message = "Congratuations! You"
      end
      puts "#{message} won." 
      self.turn_num = 10 # will exit while loop
    end
  end

  def diagonal_winner?
    middle = hidden_board[1][1]
    first_diag = hidden_board[0][0] + middle + hidden_board[2][2]
    second_diag = hidden_board[0][2] + middle + hidden_board[2][0] 
    if first_diag == 3 || second_diag == 3 || first_diag == -3 || second_diag == -3
      return true
    end
  end

  def horizontal_winner?
    row = 0
    while row < 3
      total = hidden_board[row][0] + hidden_board[row][1] + hidden_board[row][2] 
      if total == 3 || total == -3
        return true
      end
      row += 1
    end
  end

  def vertical_winner?
    column = 0
    while column < 3
      total = hidden_board[0][column] + hidden_board[1][column] + hidden_board[2][column]
      if total == 3 || total == -3
        return true
      end
      column += 1
    end
  end
end

game = TicTacToe.new
game.main