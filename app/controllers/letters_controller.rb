require 'open-uri'
require 'json'

class LettersController < ApplicationController

  def play
    @letters = []
    9.times do
      @letters << ('a'..'z').to_a.sample
    end
    @start_time = Time.now
  end

  def result
    @end_time = Time.now
    @input = params[:answer]
    url = "https://wagon-dictionary.herokuapp.com/#{@input}"
    grid_tester = @input.upcase.chars.all? { |l| params[:grid].upcase.split('').include?(l) }
    count_tester = @input.upcase.chars.all? { |l| @input.count(l) <= params[:grid].count(l) }
    dict_tester = JSON.parse(URI.open(url).read)
    @total_time = (@end_time - params[:start].to_time).to_i
    if grid_tester && dict_tester["found"] && count_tester
      @score = (@input.size.to_i * 10) / @total_time
      @returned = { score: @score, message: 'well done', time: @total_time }
    elsif !count_tester || !grid_tester
      @returned = { score: 0, message: 'not in the grid', time: @total_time }
    elsif !dict_tester['found']
      @returned = { score: 0, message: 'not an english word', time: @total_time }
    end
  end
end
