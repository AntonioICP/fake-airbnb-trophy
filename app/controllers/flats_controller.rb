class FlatsController < ApplicationController
  def index
    @flats = Flat.all
    @request = Request.new
  end

  def show
    @flat = Flat.find(params[:id])
    @request = Request.new
  end
end
