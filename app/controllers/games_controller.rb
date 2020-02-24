require 'json'
require 'open-uri'

class GamesController < ApplicationController
  ALPHABET = ('A'..'Z').to_a
  def new
    @letters = []
    10.times { @letters << ALPHABET.sample }
  end

  def score
    @answer = params[:answer].split(//)
    @letters = params[:letters].downcase.split

    if valid_answer?(@answer, @letters) & valid_english_word?(params[:answer])
      @message = "Congratulations! #{@answer.join} is a valid English word!"
    elsif !valid_answer?(@answer, @letters)
      @message = "Sorry but #{@answer.join.upcase} can't be build out of #{@letters.join(", ").upcase}"
    else
      @message = "Sorry but #{@answer.join.upcase} does not seem to be a valid English word..."
    end
  end

  def valid_answer?(answer_array, letter_array)
    answer_hash = Hash.new(0)
    letter_hash = Hash.new(0)

    answer_array.each do |letter|
      answer_hash[letter] += 1
    end

    letter_array.each do |letter|
      letter_hash[letter] += 1
    end
    answer_hash.all? { |key, _value| letter_hash[key] >= answer_hash[key] }
  end

  def valid_english_word?(string)
    url = "https://wagon-dictionary.herokuapp.com/#{string}"
    dictionary = JSON.parse(open(url).read)
    dictionary['found']
  end
end
