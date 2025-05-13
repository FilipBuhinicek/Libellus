class ReservationsController < ApplicationController
  before_action :load_reservations, only: [ :index ]
  before_action :load_reservation, only: [ :show, :update, :destroy ]

  def index
    render json: @reservations
  end

  def show
    render json: @reservation
  end

  def create
    reservation = Reservation.new(reservation_params)

    if reservation.save
      render json: reservation, status: :created
    else
      render json: reservation.errors, status: :unprocessable_entity
    end
  end

  def update
    if @reservation.update(reservation_params)
      render json: @reservation
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
    @reservations = Reservation.all
  end
  def load_reservation
    @reservation = Reservation.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Reservation not found" }, status: :not_found
  end

  def reservation_params
    params.require(:reservation).permit(:reservation_date, :expiration_date, :user_id, :book_id)
  end
end
