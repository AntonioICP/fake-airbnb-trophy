class FlatsController < ApplicationController
  def index
    @flats = Flat.all
    @flat = Flat.new
  end

  def show
    @flat = Flat.find(params[:id])
  end
end
