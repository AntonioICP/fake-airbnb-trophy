class FlatsController < ApplicationController

  # def skip_pundit?
  #   true
  # end

  def index
    # @flats = policy_scope(Flat)
    @flats = Flat.all
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
    @unavailable_dates = @flat.requests
                                 .where.not(id: @request.id)
                                 .where(approved: true)
                                 .pluck(:start_date, :end_date)
                                 .map { |range| { from: range[0], to: range[1] } }
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
