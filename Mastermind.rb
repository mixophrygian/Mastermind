class Mastermind

	def initialize
		@allowed_guesses = 12
		@won = false
		@current_guess = []
		@all_guesses =[]
		@red_indexes = []
		@current_feedback = []
		@all_feedback = []
		@secret_code = []

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
a correct color in the incorrect slot (white peg for each one).  Duplicate colors are permitted.  The code breaker \
only has twelve guesses!" 
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
single space, like this: \"Blue White Red Red\" \n"
		@secret_code = generate_secret_code
		print @secret_code
		while @won == false && @allowed_guesses > 0
			prompt_guess
			check_for_win(@current_guess)
			generate_feedback
			unless @won
				display_board
				@allowed_guesses -= 1
				if @allowed_guesses == 0 
					puts "You Lose :( :( :(" 
				end
			end
		end
	end

	def make_code
		puts "\nYou have chosen... \n   ___         _       __  __      _           
  / __|___  __| |___  |  \\/  |__ _| |_____ _ _ 
 | (__/ _ \\/ _` / -_) | |\\/| / _` | / / -_) '_|
  \\___\\___/\\__,_\\___| |_|  |_\\__,_|_\\_\\___|_|  
                                               
		" 
		#IMPLEMENT
		puts "whoops we haven't written this choice yet. Stay tuned!"
	end

	def generate_secret_code
		colors = ["black", "white", "red", "yellow", "green", "blue"]
		slots = 4
		secret_code = []
		#allows for duplicate colors.  To prevent duplicates replace this block with "secret_code << colors.sample(slots)"
		slots.times do 
			secret_code << colors.sample
		end
		return secret_code
	end

	def prompt_guess
		puts "\nYou have #{@allowed_guesses} guess(es) remaining.  GUESS!\n"
		guess = gets.chomp.downcase.split(' ')
		while !check_for_valid_guesses(guess)
		 puts "\nAt least one of your guesses was invalid, please enter them again, separated by a single space like this: \"red green yellow white\" \n "
		 guess = gets.chomp.downcase.split(' ')
		end
		@current_guess = guess
		@all_guesses << @current_guess
	end

	def check_for_valid_guesses(guess)
		valid = true
		valid_colors = ["black", "white", "red", "yellow", "green", "blue"]
		guess.each do  |guess|
			unless valid_colors.include?(guess)
				valid = false
			end
		end
		valid
	end

	def generate_feedback
	@current_feedback = []
	reds = count_reds
	whites = count_whites
	whites.times { @current_feedback << "White"}
	reds.times { @current_feedback << "Red"}
	@all_feedback << @current_feedback
	end

	def count_reds
		@red_indexes = []
		count = 0
		@current_guess.each_with_index do |peg, index|
			if peg == @secret_code[index]
				count += 1
				@red_indexes << index 
			end
		end
		return count
	end

	def count_whites
		count = 0
		temp_guess = []
		temp_code = []
		@current_guess.each_with_index do |peg, index|
			if @red_indexes.include?(index)
				next
			end
			temp_guess << peg
			temp_code << @secret_code[index]
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

	def check_for_win(guess)
		if guess == @secret_code
			puts "YOU BROKE THE CODE! YOU ARE A...
			
  __  __           _____ _______ ______ _____  __  __ _____ _   _ _____  
 |  \\/  |   /\\    / ____|__   __|  ____|  __ \\|  \\/  |_   _| \\ | |  __ \\ 
 | \\  / |  /  \\  | (___    | |  | |__  | |__) | \\  / | | | |  \\| | |  | |
 | |\\/| | / /\\ \\  \\___ \\   | |  |  __| |  _  /| |\\/| | | | | . ` | |  | |
 | |  | |/ ____ \\ ____) |  | |  | |____| | \\ \\| |  | |_| |_| |\\  | |__| |
 |_|  |_/_/    \\_\\_____/   |_|  |______|_|  \\_\\_|  |_|_____|_| \\_|_____/ 

 "

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

