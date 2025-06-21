class FlatsController < ApplicationController
  def index
    if params[:query].present?
      @flats = Flat.search(params[:query], suggest: true).results
      flash[:alert] = "No results found for \"#{params[:query]}\"" if @flats.empty?
    else
      @flats = Flat.all
    end

    @markers = @flats.select(&:geocoded?).map do |flat|
      {
        id: flat.id,
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

def autocomplete
  results = Flat.search(params[:term], fields: [:address], limit: 5, load: false, misspellings: { below: 5 })
  render json: results.map { |flat| { label: flat.address, value: flat.address } }
end

end
