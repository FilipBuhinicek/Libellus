class ReservationsController < ApplicationController
  before_action :authenticate_request
  before_action :load_reservations, only: [ :index ]
  before_action :load_reservation, only: [ :show, :update, :destroy ]
  before_action :authorize_resource, only: [ :show, :update, :destroy ]
  before_action :authorize_class, only: [ :index ]

  def index
    render json: ReservationSerializer.new(filtered_reservations).serializable_hash
  end

  def show
    render json: ReservationSerializer.new(@reservation).serializable_hash
  end

  def create
    reservation = Reservation.new(reservation_params)

    authorize reservation

    book = reservation.book

    if book.copies_available <= 0
      render json: { error: "Book is not available for reservation." }, status: :unprocessable_entity
      return
    end

    if reservation.save
      book.update(copies_available: book.copies_available - 1)
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
    if @reservation
      @reservation.book.update(copies_available: @reservation.book.copies_available + 1)
    end
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

  def filtered_reservations
    reservations = @reservations

    reservations = reservations.where(user_id: params[:user_id]) if params[:user_id].present?
    reservations = reservations.where(book_id: params[:book_id]) if params[:book_id].present?

    if params[:expired].present?
      case params[:expired]
      when "true"
        reservations = reservations.where("expiration_date < ?", Date.today)
      when "false"
        reservations = reservations.where("expiration_date >= ?", Date.today)
      end
    end

    reservations
  end
end
