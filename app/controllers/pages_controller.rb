require 'net/http'
require 'json'
class PagesController < ApplicationController
  def new
    letters = ('a'..'z').to_a
    @array = []
    10.times do
      @array << letters.sample.upcase.to_s
    end
    @array
  end

  def score
    @answer_array = params[:answer].upcase.chars
    @letters = params[:letters].split
    if valid_word?(@answer_array.join) && contains?(@answer_array, @letters)
      @return = 'Your word is valid!'
      @score = (@answer_array.size**2)
    elsif valid_word?(@answer_array.join) && !contains?(@answer_array, @letters)
      @return = 'Your word isn\'t in the grid!'
    else
      @return = 'Your word is not a valid word!'
    end
  end

  def valid_word?(answer)
    url = "https://wagon-dictionary.herokuapp.com/#{answer}"
    uri = URI(url)
    response = Net::HTTP.get(uri)
    json = JSON.parse(response)
    json['found']
  end

  def contains?(answer_array, array)
    answer_array.all? do |letter|
      answer_array.count(letter) <= array.count(letter)
    end
  end
end