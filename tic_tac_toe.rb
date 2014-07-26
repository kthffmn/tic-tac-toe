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
    if turn_num % 2 == 0
      return false
    else
      return true
    end
  end

  def placeholder
    if user_turn?
      return "O"
    else 
      return "X"
    end
  end

  def number
    if user_turn?
      return 1
    else
      return -1
    end
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

  def get_free_spaces
    spaces = []
    hidden_board.each do |row|
      row.each do |space|
        if space == 0
          spaces << [hidden_board.index(row), row.index(space)]
        end
      end
    end
    spaces
  end

  def try_to_win(free_spaces)
    hidden_board_copy = hidden_board
    free_spaces.each do |coordinates|
      hidden_board_copy[coordinates[0]][coordinates[1]] == -1
      if winner?(hidden_board_copy)
        return coordinates
      end
    end
    return nil
  end

  def be_defensive(free_spaces)
    hidden_board_copy = hidden_board
    free_spaces.each do |coordinates|
      hidden_board_copy[coordinates[0]][coordinates[1]] == 1
      if winner?(hidden_board_copy)
        return coordinates
      end
    end
    return nil
  end

  def computers_turn
    puts "Here's my move:"
    free_spaces = get_free_spaces
    next_move = nil
    next_move ||= try_to_win(free_spaces)
    next_move ||= be_defensive(free_spaces)
    next_move ||= free_spaces.sample
    binding.pry
    return next_move
  end

  ######################
  ## check for winner ##
  ######################

  def winner?(board)
    if diagonal_winner?(board) || horizontal_winner?(board) || vertical_winner?(board)
      return true
    else
      return false
    end
  end

  def check_for_winner
    if winner?(hidden_board)
      message = "I"
      if user_turn?
        message = "Congratuations! You"
      end
      puts "#{message} won." 
      self.turn_num = 10 # will exit while loop
    end
  end

  def diagonal_winner?(board)
    middle = board[1][1]
    first_diag = board[0][0] + middle + board[2][2]
    second_diag = board[0][2] + middle + board[2][0] 
    if first_diag == 3 || second_diag == 3 || first_diag == -3 || second_diag == -3
      return true
    end
  end

  def horizontal_winner?(board)
    row = 0
    while row < 3
      total = board[row][0] + board[row][1] + board[row][2] 
      if total == 3 || total == -3
        return true
      end
      row += 1
    end
  end

  def vertical_winner?(board)
    column = 0
    while column < 3
      total = board[0][column] + board[1][column] + board[2][column]
      if total == 3 || total == -3
        return true
      end
      column += 1
    end
  end
end

game = TicTacToe.new
game.main