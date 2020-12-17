# https://www.cs.rochester.edu/~brown/173/readings/05_grammars.txt
#
#  "TINY" Grammar
#
# PGM        -->   STMT+
# STMT       -->   ASSIGN   |   "print"  EXP                           
# ASSIGN     -->   ID  "="  EXP
# EXP        -->   TERM   ETAIL
# ETAIL      -->   "+" TERM   ETAIL  | "-" TERM   ETAIL | EPSILON
# TERM       -->   FACTOR  TTAIL
# TTAIL      -->   "*" FACTOR TTAIL  | "/" FACTOR TTAIL | EPSILON
# FACTOR     -->   "(" EXP ")" | INT | ID   
#                  
# ID         -->   ALPHA+
# ALPHA      -->   a  |  b  | … | z  or 
#                  A  |  B  | … | Z
# INT        -->   DIGIT+
# DIGIT      -->   0  |  1  | …  |  9
# WHITESPACE -->   Ruby Whitespace

#
#  Class Scanner - Reads a TINY program and emits tokens
#

class Scanner 
$error = false
# Constructor - Is passed a file to scan and outputs a token
#               each time nextToken() is invoked.
#   @c        - A one character lookahead 

	def initialize(filename)

		# Need to modify this code so that the program
		# doesn't abend if it can't open the file but rather
		# displays an informative message
		# Go ahead and read in the first character in the source
		# code file (if there is one) so that you can begin
		# lexing the source code file 
		if File.exists?(filename)
			@f = File.open(filename,'r:utf-8')
			if (! @f.eof?)
				@c = @f.getc()
			else
				@c = "!eof!"
				@f.close()
			end
		else
			$error = true
		end
	end

	def checkError()
		return $error
	end
	
	# Method nextCh() returns the next character in the file

	def nextCh()
		if (! @f.eof?)
			@c = @f.getc()
		else
			@c = "!eof!"
		end
		
		return @c
	end

	# Method nextToken() reads characters in the file and returns
	# the next token

	def nextToken() 
		if @c == "!eof!"
			return Token.new(Token::EOF,"eof")
				
		elsif (whitespace?(@c))
			str =""
		
			while whitespace?(@c)
				str += @c
				nextCh()
			end
		
			tok = Token.new(Token::WS,str)
			return tok
		elsif (letter?(@c))
			str =""
			
			while letter?(@c)
				str += @c
				nextCh()
			end
			if (str == "print") 
				tok = Token.new(Token::PRINT,str)
			else
				tok = Token.new(Token::ID,str)
			end
		elsif (numeric?(@c))
			str = @c
			
			if (whitespace?(nextCh()))
				tok = Token.new(Token::INT,str)
			else
				tok = Token.new("unknown", "unknown")	
			end
		elsif (@c == "*")
			str = @c
			
			tok = Token.new(Token::MULOP,str)
		elsif (@c == "/")
			str = @c
			
			if (whitespace?(nextCh()))
				tok = Token.new(Token::DIVOP,str)
			else
				tok = Token.new("unknown", "unknown")	
			end
		elsif (@c == "+")
			str = @c
			
			tok = Token.new(Token::ADDOP,str)
		elsif (@c == "-")
			str = @c
			
			tok = Token.new(Token::SUBOP,str)
		elsif (@c == "(")
			str = @c
			
			tok = Token.new(Token::LPAREN,str)
		elsif (@c == ")")
			str = @c
			
			tok = Token.new(Token::RPAREN,str)
		elsif (@c == "=")
			str = @c
			
			tok = Token.new(Token::ASSIGN,str)
		else
			tok = Token.new("unknown","unknown")

		end
	
end

def letter?(lookAhead)
	lookAhead =~ /^[a-z]|[A-Z]$/
end

def numeric?(lookAhead)
	lookAhead =~ /^(\d)+$/
end

def whitespace?(lookAhead)
	lookAhead =~ /^(\s)+$/
end

end




