class ReservationsController < ApplicationController
  before_action :authenticate_request
  before_action :load_reservations, only: [ :index ]
  before_action :load_reservation, only: [ :show, :update, :destroy ]
  before_action :authorize_resource, only: [ :show, :update, :destroy ]
  before_action :authorize_class, only: [ :index ]

  def index
    render json: ReservationSerializer.new(@reservations).serializable_hash
  end

  def show
    render json: ReservationSerializer.new(@reservation).serializable_hash
  end

  def create
    reservation = Reservation.new(reservation_params)

    authorize reservation

    if reservation.save
      render json: ReservationSerializer.new(reservation).serializable_hash, status: :created
    else
      render json: reservation.errors, status: :unprocessable_entity
    end
  end

  def update
    if @reservation.update(reservation_params)
      render json: ReservationSerializer.new(@reservation).serializable_hash
    else
      render json: @reservation.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @reservation.destroy
    head :no_content
  end

  private

  def load_reservations
    @reservations = policy_scope(Reservation)
  end
  def load_reservation
    @reservation = Reservation.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Reservation not found" }, status: :not_found
  end

  def reservation_params
    params.require(:reservation).permit(:reservation_date, :expiration_date, :user_id, :book_id)
  end

  def authorize_resource
    authorize @reservation
  end

  def authorize_class
    authorize Reservation
  end
end
