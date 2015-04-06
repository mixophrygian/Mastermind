class Mastermind

	def initialize
		@allowed_guesses = 12
		@won = false
		@current_guess = []
		@all_guesses =[]
		@red_indexes = []
		@current_feedback = []
		@previous_feedback = []
		@all_feedback = []
		@secret_code = []
		@colors = ["black", "white", "red", "yellow", "blue", "green"]
		@slots = 4
		@all_possible_codes = @colors.repeated_permutation(@slots).to_a

		intro
		if choose_game == "breaker"
			break_code
		else
			make_code
		end
	end

def intro
		puts "\nWelcome to..."
		puts "  __  __            _                     _           _ 
 |  \\/  | __ _  ___| |_  ___  _ _  _ __  (_) _ _   __| |
 | |\\/| |/ _` |(_-<|  _|/ -_)| '_|| '  \\ | || ' \\ / _` |
 |_|  |_|\\__,_|/__/ \\__|\\___||_|  |_|_|_||_||_||_|\\__,_|"
    puts "\nDo you know how to play?"
    answer = gets.chomp.downcase
    until answer == "yes" || answer == "no"
    	puts "Yes or no.  Do you know how to play?"
    	answer = gets.chomp.downcase
    end
    give_instructions if answer == "no"
  end

def give_instructions
  	puts "\nMaster Mind is a code-breaking game for two players.  One player (code maker) creates a secret code\
 using colored pegs (black, white, red, yellow, green or blue) in four different slots.  The \
colors and their exact order constitute the code. The other player (code breaker) has twelve \
attempts to guess the secret code.  After each guess the code maker will give feedback on the \
most recent guess.  The code maker will tell the code breaker whether or not their guess contained \
a correct color in the correct slot (red peg for each one) and whether or not their guess contained \
a correct color in the incorrect slot (white peg for each one).  The feedback received doesn't indicate \
which exact slots are correct, only that one or more of your guess pegs includes an exact or near match. \
Duplicate colors are permitted.  The code breaker only has twelve guesses!" 
end

def choose_game
	puts "\nWould you like to play as code maker or code breaker? \n Type: \"maker\" or \"breaker\".\n"
	choice = gets.chomp.downcase
	until choice == "maker" || choice == "breaker"
		puts "\n\n Type: \"maker\" or \"breaker\"."
		choice = gets.chomp.downcase
	end
		return choice
end

def break_code
		puts "\nYou have chosen... \n   ___         _       ___              _           
  / __|___  __| |___  | _ )_ _ ___ __ _| |_____ _ _ 
 | (__/ _ \\/ _` / -_) | _ \\ '_/ -_) _` | / / -_) '_|
  \\___\\___/\\__,_\\___| |___/_| \\___\\__,_|_\\_\\___|_|  
                                                    
Choose four pegs of any colors. \
Duplicates are permitted.  Colors: Black, White, Red, Yellow, Blue, or Green.  Enter them separated by a \
single space, like this: \"red white blue blue\" \n"
		@secret_code = generate_secret_code
		while @won == false && @allowed_guesses > 0
			play(user_guess, "You")
		end
	end

def make_code
	puts "\nYou have chosen... \n   ___         _       __  __      _           
  / __|___  __| |___  |  \\/  |__ _| |_____ _ _ 
 | (__/ _ \\/ _` / -_) | |\\/| / _` | / / -_) '_|
  \\___\\___/\\__,_\\___| |_|  |_\\__,_|_\\_\\___|_|  
                                               				"
  puts "Create a secret code made up of a sequence of four pegs from any six colors: Black, White, Red, \
  Yellow, Blue, or Green.  Enter them separated by a single space, like this \"green white white red\". Duplicates are permitted. \n\n"

  @secret_code = request_user_code

  while @won == false && @allowed_guesses > 0
			play(computer_guess, "The computer")
		end
end

def play(game_type, player_name)
		game_type
		generate_feedback(@current_guess, @secret_code)
		@all_feedback << @current_feedback
		@previous_feedback = @current_feedback
		display_board
		check_for_win(@current_guess, player_name)
		unless @won
			@allowed_guesses -= 1
			if @allowed_guesses == 0 
				puts "\nThe secret code was #{@secret_code}"
				puts "\n

 __     __           _      ____   _____ ______ 
 \\ \\   / /          | |    / __ \\ / ____|  ____|
  \\ \\_/ /__  _   _  | |   | |  | | (___ | |__   
   \\   / _ \\| | | | | |   | |  | |\\___ \\|  __|  
    | | (_) | |_| | | |___| |__| |____) | |____ 
    |_|\\___/ \\__,_| |______\\____/|_____/|______|
                                                " 
			end
		end
end
		
def request_user_code
	  code = gets.chomp.downcase.split(' ')
  while !check_for_valid(code)
  	puts "\nAt least one of your code elements was invalide, please enter them again separated by a single space like this \"green black white red\".  \n"
  	code = gets.chomp.downcase.split(' ')
  end
 return code
end

def generate_secret_code
		secret_code = []
		#allows for duplicate colors.  To prevent duplicates replace this block with "secret_code << colors.sample(slots)"
		@slots.times do 
			secret_code << @colors.sample
		end
		return secret_code
	end

def computer_guess
	#Loosely based on Donald Knuth's algorithm for five or fewer guesses
	if @allowed_guesses == 12
		guess = random_initial_guess
	else
		remove_ineligible_guesses
		guess = @all_possible_codes.sample
	end
	@current_guess = guess
	@all_guesses << @current_guess
end

def remove_ineligible_guesses
	@all_possible_codes.reject! do |code| 
		generate_feedback(code, @current_guess) != @previous_feedback
	end
end


def random_initial_guess
	two_colors = @colors.sample(2)
	guess = [two_colors[0], two_colors[0], two_colors[1], two_colors[1]]
	return guess
end

def user_guess
		puts "\nYou have #{@allowed_guesses} guess(es) remaining.  GUESS!\n"
		guess = gets.chomp.downcase.split(' ')
		while !check_for_valid(guess)
		 puts "\nAt least one of your guesses was invalid, please enter them again, separated by a single space like this: \"red green yellow white\" \n "
		 guess = gets.chomp.downcase.split(' ')
		end
		@current_guess = guess
		@all_guesses << @current_guess
end

def check_for_valid(guess)
		valid = true
		valid_colors = ["black", "white", "red", "yellow", "green", "blue"]
		guess.each do  |guess|
			unless valid_colors.include?(guess)
				valid = false
			end
		end
		valid
end

def generate_feedback(guess, secret)
	@current_feedback = []
	reds = count_reds(guess, secret)
	whites = count_whites(guess, secret)
	whites.times { @current_feedback << "White"}
	reds.times { @current_feedback << "Red"}
	return @current_feedback
end

def count_reds(guess, secret)
		@red_indexes = []
		count = 0
		guess.each_with_index do |peg, index|
			if peg == secret[index]
				count += 1
				@red_indexes << index 
			end
		end
		return count
end

def count_whites(guess, secret)
		count = 0
		temp_guess = []
		temp_code = []
		guess.each_with_index do |peg, index|
			if @red_indexes.include?(index)
				next
			end
			temp_guess << peg
			temp_code << secret[index]
		end
		temp_guess.each do |peg|
			if temp_code.include?(peg)
				count += 1
				temp_code.delete_at(temp_code.index(peg))
			end
		end
		return count
end

def display_board
		counter = 1
		@all_guesses.each_with_index do |guess, index| 
			print "\n" + "Guess # #{counter}: " + guess.to_s + "     Feedback: " + @all_feedback[index].to_s + "\n"
			counter += 1
		end
end

	def check_for_win(guess, player_name)
		if guess == @secret_code 
			if player_name == "You"
				puts "YOU BROKE THE CODE!  In only #{13-@allowed_guesses} guesses. YOU ARE A...

  __  __           _____ _______ ______ _____  __  __ _____ _   _ _____  
 |  \\/  |   /\\    / ____|__   __|  ____|  __ \\|  \\/  |_   _| \\ | |  __ \\ 
 | \\  / |  /  \\  | (___    | |  | |__  | |__) | \\  / | | | |  \\| | |  | |
 | |\\/| | / /\\ \\  \\___ \\   | |  |  __| |  _  /| |\\/| | | | | . ` | |  | |
 | |  | |/ ____ \\ ____) |  | |  | |____| | \\ \\| |  | |_| |_| |\\  | |__| |
 |_|  |_/_/    \\_\\_____/   |_|  |______|_|  \\_\\_|  |_|_____|_| \\_|_____/ 

"			elsif player_name == "The computer"
				puts "\nThe computer cracked your code in only #{13-@allowed_guesses} guesses.  ¯\\_(ツ)_/¯"
				end
 			@won = true
		end
	end
end

play_again = "yes"
##gameplay starts here
while play_again == "yes" do
	game = Mastermind.new
	puts "\n Play again?"
	play_again = gets.chomp.downcase
end

