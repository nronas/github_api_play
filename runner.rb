require 'httparty'

require_relative 'lib/github'
require_relative 'lib/github_user'
require_relative 'lib/github_repos'

welcome_message =
"""
# ------------------------------------------------------ #
# Welcome to Github user prefered language extraction.   #
# This app is for trying to find out what coding monkeys #
# likes to use.                                          #
# ------------------------------------------------------ #
"""

prompt_symbol = " :> "
puts welcome_message

loop do
  puts " Please give the coding monkey's username."
  print prompt_symbol
  input = gets.chomp

  case input
  when /exit/i
    break
  when /welcome/i
    puts welcome_message
  else
    begin
      user = Github::User.find(input)
      puts "Coding monkey(#{input}) has prefered language #{user.prefered_language}!"
    rescue Exception => e
      puts e.message
    end
  end
end

puts "Bye!"
