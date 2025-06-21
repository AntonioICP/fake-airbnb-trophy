class RequestsController < ApplicationController
  before_action :set_request, only: %i[edit update show destroy]

  after_action :verify_authorized, except: [:index, :show, :create, :update], unless: :skip_pundit?


def index
  if user_signed_in?
    @requests = current_user.requests
    @markers = @requests.map(&:flat).compact.select(&:geocoded?).map do |flat|
      {
        id: flat.id,
        lat: flat.latitude,
        lng: flat.longitude
      }
    end
  else
    redirect_to root_path
  end
  @requests = policy_scope(Request)
end

  def show
    authorize @request
    @unavailable_dates = @request.flat.requests
                                 .where.not(id: @request.id)
                                 .where(approved: true)
                                 .pluck(:start_date, :end_date)
                                 .map { |range| { from: range[0], to: range[1] } }
    @markers = [
      {
        lat: @request.flat.latitude,
        lng: @request.flat.longitude
      }
    ]
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
    authorize @request
  end

  def edit

  end

  def update
    puts "👀 Params received: #{params.inspect}"
    if params[:request][:approved].present?
      params[:request][:approved] = ActiveModel::Type::Boolean.new.cast(params[:request][:approved])
    end
    if request_params[:start_date] != @request.start_date.to_s || request_params[:end_date] != @request.end_date.to_s
      @request.approved = nil
    end


    if @request.update(request_params)
      redirect_back fallback_location: request_path(@request), notice: "Request updated!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @request.destroy
    redirect_to requests_path, status: :see_other
  end

  private

  def set_request
    @request = Request.find(params[:id])
  end

  def request_params
    params.require(:request).permit(:start_date, :end_date, :approved)
  end
end
