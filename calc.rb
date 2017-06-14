# Evan Ko
# CSE 413
# 12/08/16

require_relative("scan.rb")

class Calc

	def initialize
		@idHash = {"PI"=>Math::PI}
		intro 
	    @scanner = Scanner.new(gets)
	    @token = @scanner.next_token

	    program()
	end

	private
	def intro
		puts ' Welcome to the CSE 413 Calculator.'
		puts 'Addition         :           17 + 42'
		puts 'Subtraction      :           17 - 42'
		puts 'Multiplication   :           17 * 42'
		puts 'Division         :           17 / 42'
		puts 'Power            :          17 ** 42'
		puts 'Square Root      :          sqrt(17)'
		puts 'Absolute Value   :           abs(42)'
		puts 'Negative numbers :               -17'
		puts
		puts 'Expressions      : (2 / 4) + (4 / 2)'
		puts
		puts 'Assignment       :            n = 42'
		puts 'Identifier use   :            17 + n'
		puts 'Unassignment     :           unset n'
		puts 'List identifiers :              list'
		puts
		puts 'Statement chains :     n = 1 ; n + 2'
		puts
		puts 'Exit the program :       quit | exit'
		puts
	end

	def get_token
	    token = @token
	    @token = @scanner.next_token
	    return token
  	end

  	def next_token
    	@token = @scanner.next_token
  	end

	def peek_token
   		 @scanner.peak
  	end

  	def has_next_token
   		@scanner.has_next_token
  	end

  	def program
	    # keep going until user exit/quit
	    while true

	      # more input?
	      if @scanner.has_next_token
	        puts statement

	        # EOL -separated statements?
	        while @token.kind == 'EOL' && has_next_token && peek_token.kind != 'EOL'
	          get_token # consume EOL
	          puts statement
	        end
	      end
	      @scanner.tokenize(gets)
	      next_token
	    end
  	end

  	def statement
	    temp = peek_token().kind

	    # identifier assignment?
	    if @token.kind == 'ID' && temp == 'EQUAL'
	      id = get_token.value # save ID
	      next_token # consume =
	      result = exp()
	      @idhash[id] = result

	    # identifier unset?
	    elsif @token.value == 'clear' && temp == 'ID'
	      id = next_token.value # consume clear
	      next_token # consume ID
	      @idhash.delete(id)

	    # identifier list?
	    elsif @token.value == 'list'
	    	 result = ''
      		@idHash.each do |key, value|
        		l = value.to_s
        		result << (key + ' =>' + ' ' * (36 - (key.length + l.length) - ' =>'.length) + l + "\n")
		      end
		      result
	    # quit // exit?
	    elsif @token.value == 'quit' || @token.value == 'exit'
	      puts
	      puts 'Exiting program'
	      exit

	    else
	      return exp()
	    end
  	end

  	def exp
	 	result = term()
	    # recursive expression?
	    while (n_token = @token.kind) == 'PLUS' || n_token == 'MINUS'

	      # addition?
	      if n_token == 'PLUS'
	        next_token # consume +
	        result = result + term()
	      end

	      # subtraction?
	      if n_token == 'MINUS'
	        next_token # consume -
	        result = result - term()
	      end
	    end
	    return result
  	end

	def term
	    result = power

	    # recursive expression?
	    while (n_token = @token.kind) == 'TIMES' || n_token == 'DIVIDE'

	      # multiplication?
	    	if n_token == 'TIMES'
		        next_token # consume +
		        result = result * power
	    	elsif(n_token == 'DIVIDE')
		        next_token # consume -
		        result = result / power
	     	end
	    end
	    return result
  	end

  	def power
	    result = factor

	    # recursive expression?
	    while @token.kind == 'EXPONENT'
	      next_token #consume **
	      next_token
	      result = result ** power
	    end
	    return result
  	end

  	def factor
	    case @token.kind

	      # identifier?
	      when 'ID'
	        if (stored = @idhash[@token.value])
	          next_token
	          stored
	        else
	         "ERR: unbound identifier '#{@token.value}'"
	        end

	      # number?
	      when 'number'
	        return get_token.value

	      # parenthesized expression?
	      when 'LPAREN'
	        next_token # consume )
	        result = exp
	        if @token.kind != 'RPAREN'
	          raise 'ERROR: no closing parenthesis'
	        end
	        next_token # consume )
	        return result
          when 'abs'
          	next_token #consume abs
          	next_token #consume (
          	result = exp()
	        if @token.kind != 'RPAREN'
	          raise 'ERROR: no closing parenthesis'
	        end
	        next_token # consume )
	        return result

	      # square root expression?
	      when 'sqrt'
	        next_token # consume sqrt
	        next_token # consume (
	        result = Math.sqrt(exp())
	        if @token.kind != 'RPAREN'
	          raise 'ERROR: no closing parenthesis'
	        end
	        next_token # consume )
	        return result

	      # invalid token?
	      when 'INVALID'
	        "ERR: improper syntax near #{@token.value}"
	    end
	end


end

Calc.new
