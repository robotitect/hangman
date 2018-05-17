require_relative "game.rb"
puts "Would you like to load a save? [y/n]"
if(["Y","y"].include?(gets.chomp[0]))
  puts "Enter the filename"
  filename = gets.chomp
  Game.load_from_file(filename).play_game
else
  Game.new.play_game
end
