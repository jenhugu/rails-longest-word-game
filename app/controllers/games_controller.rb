require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @word = params[:word]
    @letters = params[:letters].split('')

    @result = check_word(@word, @letters)
    render :score
  end

  private

  def check_word(word, letters)
    # Vérifier si le mot peut être formé avec les lettres
    word_letters = word.upcase.chars
      if word_letters.all? { |letter| word_letters.count(letter) <= letters.count(letter) }
        # Vérifier si le mot existe dans le dictionnaire
        if english_word?(word)
          { valid: true, message: "Congratulations! #{word.upcase} is a valid word!" }
        else
          { valid: false, message: "Sorry, #{word.upcase} doesn't seem to be an English word..." }
        end
      else
        { valid: false, message: "Sorry, #{word.upcase} can't be built out of #{letters.join(', ')}" }
      end
  end

  def english_word?(word)
    response = URI.open("https://dictionary.lewagon.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end
end
