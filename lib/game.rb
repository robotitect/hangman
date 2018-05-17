require "yaml"

class Game
  MAX_INCORRECT_GUESSES = 10
  attr_accessor :incorrect_guesses, :game_word, :overall_guess, :guessed_letters

  def initialize
    @incorrect_guesses = 0
    @game_word = words_from_file().sample.downcase
    @overall_guess = "".rjust(game_word.length, "_")
    @guessed_letters = []
  end

  # TODO:
  def self.load_from_file(filename)
    return YAML::load(File.read("saves/#{filename}"))
  end

  def save_to_file
    yaml = YAML::dump(self)
    Dir.mkdir("saves") unless Dir.exists?("saves")
    filename = "saves/#{Time.now}.yaml"
    File.open(filename, "w") do |file|
      file.puts(yaml)
    end
  end

  def words_from_file(file = "5desk.txt")
    words = []
    File.foreach(file) do |line|
      words << line.strip if line.strip.length.between?(5, 12)
    end
    words
  end

  def play_game
    while(@overall_guess != game_word &&
          @incorrect_guesses < MAX_INCORRECT_GUESSES)
      print_current_guess
      puts "What letter do you guess? [1 to save]"
      guessed_letter = gets.chomp[0].downcase
      if(guessed_letter == "1")
        save_to_file
      elsif(@guessed_letters.include?(guessed_letter))
        puts "You already guessed that!"
      else
        @guessed_letters << guessed_letter
        check_letter_in_word(guessed_letter)
      end
    end
    end_game
  end

  def end_game
    if(@incorrect_guesses >= MAX_INCORRECT_GUESSES)
      puts "You died!"
    else
      puts "You won!"
    end
    puts "The word was #{@game_word}"
  end

  def check_letter_in_word(letter_to_check)
    unless(@game_word.include?(letter_to_check))
      @incorrect_guesses += 1
    else
      @game_word.each_char.with_index do |game_word_letter, index|
        if(game_word_letter == letter_to_check)
          @overall_guess[index] = letter_to_check
        end
      end
    end
  end

  def print_current_guess
    puts
    @overall_guess.each_char do |letter|
      print letter + " "
    end
    puts "\n#{MAX_INCORRECT_GUESSES - @incorrect_guesses} guesses remaining"
  end
end
