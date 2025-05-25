class BorrowingsController < ApplicationController
  before_action :authenticate_request
  before_action :load_borrowings, only: [ :index ]
  before_action :load_borrowing, only: [ :show, :update, :destroy ]
  before_action :authorize_resource, only: [ :show, :update, :destroy ]
  before_action :authorize_class, only: [ :index ]

  def index
    render json: BorrowingSerializer.new(filtered_borrowings).serializable_hash
  end

  def show
    render json: BorrowingSerializer.new(@borrowing).serializable_hash
  end

  def create
    borrowing = Borrowing.new(borrowing_params)

    authorize borrowing

    if borrowing.save
      reservation = Reservation.where(user_id: borrowing.member.id, book: borrowing.book)
                               .order(:created_at)
                               .first
      if reservation
        reservation.destroy
      else
        borrowing.book.update(copies_available: borrowing.book.copies_available - 1)
      end

      render json: BorrowingSerializer.new(borrowing).serializable_hash, status: :created
    else
      render json: borrowing.errors, status: :unprocessable_entity
    end
  end

  def update
    if @borrowing.update(borrowing_params)
      render json: BorrowingSerializer.new(@borrowing).serializable_hash
    else
      render json: @borrowing.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @borrowing
      @borrowing.book.update(copies_available: @borrowing.book.copies_available + 1)
    end
    @borrowing.destroy
    head :no_content
  end

  private

  def load_borrowings
    @borrowings = policy_scope(Borrowing)
  end

  def load_borrowing
    @borrowing = Borrowing.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Borrowing not found" }, status: :not_found
  end

  def borrowing_params
    params.require(:borrowing).permit(:book_id, :user_id, :borrow_date, :due_date, :return_date)
  end

  def authorize_resource
    authorize @borrowing
  end

  def authorize_class
    authorize Borrowing
  end

  def filtered_borrowings
    borrowings = @borrowings

    borrowings = borrowings.where(user_id: params[:user_id]) if params[:user_id].present?
    borrowings = borrowings.where(book_id: params[:book_id]) if params[:book_id].present?

    if params[:returned].present?
      case params[:returned]
      when "true"
        borrowings = borrowings.where.not(return_date: nil)
      when "false"
        borrowings = borrowings.where(return_date: nil)
      end
    end

    borrowings
  end
end
