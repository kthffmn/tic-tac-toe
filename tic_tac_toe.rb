class TicTacToe

  attr_accessor :visual_board, :turn_num, :hidden_board

  #######################
  ## initalize methods ##
  #######################

  def initialize
    @visual_board = make_board
    @hidden_board = Array.new(3) { Array.new(3, 0) }
    @turn_num = 1
    @counter = 0
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

  def print_board(board=visual_board)
    print "\n"
    board.each_with_index do |row, index| 
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
    user_input = gets.chomp.strip
    exit if user_input.downcase == "exit"
    visual_board.each_with_index do |row, row_index|
      if row.include?(user_input)
        return [row_index, row.index(user_input)]
      end
    end
    print "Please enter a valid number or type 'exit' to stop game. "
    users_turn
  end

  def get_free_spaces(board=hidden_board)
    spaces = []
    board.each_with_index do |row, row_index|
      row.each_with_index do |space, column_index|
        if space == 0
          spaces << [row_index, column_index]
        end
      end
    end
    spaces
  end

  # minimax(board, player) returns [winner, [row, column]]
  # where winner is either player, or 0 if only a tie is possible
  # and row,column is the best move to make, which will give that outcome
  def minimax(board, player)
    move_winners = []
    get_free_spaces(board).each do |row, column|
      board[row][column] = player
      @counter += 1
      if winner?(board)
        winner = player
      elsif get_free_spaces(board).empty?
        winner = 0 # tie
      else
        winner, _ = minimax(board, -player)
      end
      move_winners << [winner, [row, column]]
      board[row][column] = 0
    end

    if player == 1
      return move_winners.max
    else
      return move_winners.min
    end
  end

  def computers_turn
    free_spaces = get_free_spaces
    _, next_move = minimax(hidden_board, -1)
    formated_counter = @counter.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
    puts "Analyzed #{formated_counter} board arrangements. Here is my best move:"
    @counter = 0
    return next_move
  end

  ######################
  ## check for winner ##
  ######################

  def winner?(board)
    return diagonal_winner?(board) || horizontal_winner?(board) || vertical_winner?(board)
  end

  def check_for_winner
    if winner?(hidden_board)
      message = "I"
      if user_turn?
        message = "Congratuations! You"
      end
      puts "#{message} won." 
      print "\n"
      self.turn_num = 10 # will exit while loop
    end
  end

  def diagonal_winner?(board)
    middle = board[1][1]
    first_diag = board[0][0] + middle + board[2][2]
    second_diag = board[0][2] + middle + board[2][0] 
    return first_diag.abs == 3 || second_diag.abs == 3
  end

  def horizontal_winner?(board)
    row = 0
    while row < 3
      total = board[row][0] + board[row][1] + board[row][2] 
      if total.abs == 3
        return true
      end
      row += 1
    end
    return false
  end

  def vertical_winner?(board)
    column = 0
    while column < 3
      total = board[0][column] + board[1][column] + board[2][column]
      if total.abs == 3
        return true
      end
      column += 1
    end
    return false
  end
end