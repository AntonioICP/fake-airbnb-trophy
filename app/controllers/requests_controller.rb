class RequestsController < ApplicationController
  before_action :set_request, only: %i[edit update show]

def index
  @requests = Request.all.includes(:flat)
  @markers = @requests.map(&:flat).compact.select(&:geocoded?).map do |flat|
    {
      lat: flat.latitude,
      lng: flat.longitude
    }
  end
end

  def show
  end

  def new
    @request = Request.new
  end

  def create
    if user_signed_in?
      @flat = Flat.find(params[:flat_id])
      @request = Request.new(request_params)
      @request.flat = @flat
      @request.user = current_user # Optional, if using Devise or similar
      if @request.save!
        redirect_to requests_path, notice: "Request created!"
      else
        render :new, status: :unprocessable_entity
      end
    else
      redirect_to new_user_session_path, class: "dropdown-item"
    end
  end

  def edit
  end

  def update
    if @request.update(request_params)
      redirect_back fallback_location: request_path(@request), notice: "Request updated!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_request
    @request = Request.find(params[:id])
  end

  def request_params
    params.require(:request).permit(:start_date, :end_date, :approved)
  end
end
