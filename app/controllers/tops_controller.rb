class TopsController < ApplicationController
  def top
    loop do
      @character = Character.find(rand(1...1564))
      break if !@character.path.include?("image_not_available")
    end
  end
end
