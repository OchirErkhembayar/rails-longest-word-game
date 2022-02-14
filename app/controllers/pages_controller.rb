require 'net/http'
require 'json'
class PagesController < ApplicationController
  def new
    @array = params[:letters] || Array.new(8) { ('A'..'Z').to_a.sample }
    vowels = %w[A E I O U]
    2.times { @array << vowels.sample } unless @array == params[:letters]
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
      @return = 'That is not an english word!'
    end
  end

  def valid_word?(answer)
    answer = answer.gsub(' ', '%20')
    url = "https://wagon-dictionary.herokuapp.com/#{answer.downcase}"
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
