class FlatsController < ApplicationController

  # def skip_pundit?
  #   true
  # end

  def index
    # @flats = policy_scope(Flat)
    @flats = Flat.all
    if params[:query].present?
      @flats = @flats.where("address ILIKE ?", "%#{params[:query]}%")
    end
    @markers = @flats.geocoded.map do |flat|
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
end
