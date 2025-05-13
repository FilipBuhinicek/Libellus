class BorrowingsController < ApplicationControllerž
  before_action :load_borrowings, only: [ :index ]
  before_action :load_borrowing, only: [ :show, :update, :destroy ]

  def index
    render json: @borrowings
  end

  def show
    render json: @borrowing
  end

  def create
    borrowing = Borrowing.new(borrowing_params)

    if borrowing.save
      render json: borrowing, status: :created
    else
      render json: borrowing.errors, status: :unprocessable_entity
    end
  end

  def update
    if @borrowing.update(borrowing_params)
      render json: @borrowing
    else
      render json: @borrowing.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @borrowing.destroy
    head :no_content
  end

  private

  def load_borrowings
    @borrowings = Borrowing.all
  end

  def load_borrowing
    @borrowing = Borrowing.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Borrowing not found" }, status: :not_found
  end

  def borrowing_params
    params.require(:borrowing).permit(:book_id, :user_id, :borrow_date, :due_date, :return_date)
  end
end
