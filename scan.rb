##Evan Ko
##CSE 413
##HW8
##NOte I didn't finish this before so I'm not sure if this is correct to take in a file as a param
##I'm sorry if this is wrong but this is the way I got it to work

class Scanner
	def initialize(input)
		@count = 0
		@diction = []
		@lineLength = 0;
		if(input.class.to_s == ("File"))
			@file = File.readlines 'tester1.txt'
			fileParse(@file)
		else
			tokenize(input)
		end
	end



	def fileParse(file)
		file.each do |f|
			tokenize(f)
		end
		##push end of file after everything has been put into the diction
		@diction.push(Token.new("EOF"))
	end

	def next_token
		if has_next_token()
			return @diction.shift
		else
			puts "No tokens left"
		end
	end

	##returns if there is something in the diction then there is a next token
	def has_next_token
		return !@diction.empty?
	end

	
	##shows the first element of diction
	def peak
		return @diction.first
	end

	def tokenize(fileLine)
		input = fileLine.split(//)
		while(@count < input.length) do
			case
			while input[@count].eql(' ') do
				@count += 1
			when input[@count].eql?("+") 
		 		@diction.push(Token.new("PLUS", input[@count]))
			when input[@count].eql?("-")
				newStr = input[@count+1]
				if(newStr == ' ')
					@diction.push(Token.new("MINUS", input[@count]))
				else
					@diction.push(Token.new("Neg"), input[@count])
			when input[@count].eql?("*")
				tempStr = input[@count]
				newStr = input[@count+1]
				if(newStr == "*")
					@diction.push(Token.new("EXPONENT", input[@count]))
				else
					#since not a * need to tokenize the current value
					@diction.push(Token.new("TIMES", input[@count]))
				end
			when input[@count].eql?("/")
				@diction.push(Token.new("DIVIDE", input[@count]))
			when input[@count].eql?("%")
				@diction.push(Token.new("MOD", input[@count]))
			when input[@count].eql?("(")
				@diction.push(Token.new("LPAREN"))
			when input[@count].eql?(")")
				@diction.push(Token.new("RPAREN"))
			when input[@count].eql?(";")
				@diction.push(Token.new("SCOLON"))
			when input[@count].eql?("=")
				@diction.push(Token.new("EQUAL", input[@count]))
			when (input[@count] =~ (/[a-zA-Z]/)) != nil
				char = input[@count]
				tempStr = input[@count+1]
				while (tempStr =~ (/[a-zA-Z]/)) != nil do
					char = char + tempStr
					@count += 1
					tempStr = input[@count+1]
				end
				case char
				when "list", "clear", "quit", "exit"
					@diction.push(Token.new("key", char))
				when "sqrt"
					puts 'sqrt'
					@diction.push(Token.new("sqrt", char))
				when "abs"
					@diction.push(Token.new("abs", char))
				else
					@diction.push(Token.new("ID", char))
				end
			when (input[@count] =~ /\d/) != nil
 				num = input[@count].to_s
				tempNum = input[@count+1]
				while (tempNum =~ /\d/) != nil do
					num = num + tempNum
					@count += 1
					tempNum = input[@count+1]
				end
				@diction.push(Token.new("number", num.to_f))
			when(input[@count] =~ /\n/) != nil
				@diction.push(Token.new("EOL"))
			else
				@diction.push(Token.new("other"))
			end 
			@count = @count +1
		end
		@count = 0
	end
end






class Token

	def initialize(type, value=nil)
		@type = type
		@value = value
	end
	def kind
		return @type
	end

	def value
		return @value
	end

	def to_s
		case @type
		when "id", "number"
			"This token is a " + @type + " and the value of the token is " + @value.to_s
		else
			"This token is a " + @type 
		end
	end

end
