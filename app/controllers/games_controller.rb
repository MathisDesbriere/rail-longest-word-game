class GamesController < ApplicationController
  require "json"
  require "open-uri"

  def new
    alphabet = ("a".."z").to_a
    @letters = []
    10.times do
      @letters << alphabet.sample
    end
  end

  def score
    @input = params[:word]
    @letters = JSON.parse(params[:letters])
    @condition1 = true
    # parsing
    url = "https://wagon-dictionary.herokuapp.com/#{@input}"
    disctionnary_serialized = URI.open(url).read
    @dictionary = JSON.parse(disctionnary_serialized)

    # checking if the word belongs to  the letters
    @input.split("").each do |letter|
      if @letters.include?(letter)
        index = @letters.index(letter)
        @letters.delete_at(index)
      else
        @condition1 = false
      end
    end

    # checking if the word belongs to the dictionary
    @condition2 = @dictionary['found']

    # giving the score considering the two @conditions
    if @condition1 && @condition2
      @score = @dictionary['length']
      @result = true
      @message = "Congrats! Your score is: #{@score}"
    elsif @condition1
      @score = 0
      @result = false
      @message = "Your word doen't belong to the dictionary..."
    elsif @condition2
      @score = 0
      @result = false
      @message = "Your word doesn't belong to the grid..."
    else
      @score = 0
      @result = false
      @message = "It seems your word isn't english and doesn't belong to the grid..."
    end
  end
end
