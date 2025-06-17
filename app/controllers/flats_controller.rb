class FlatsController < ApplicationController
  def index
    @flats = Flat.all
    if params[:query].present?
      @flats = @flats.where("name ILIKE ?", "%#{params[:query]}%")
    end
    @markers = @flats.geocoded.map do |flat|
      {
        lat: flat.latitude,
        lng: flat.longitude
      }
    end
  end

  def show
    @flat = Flat.find(params[:id])
    @request = Request.new
    @markers = [
      {
        lat: @flat.latitude,
        lng: @flat.longitude
      }
    ]
  end
end
