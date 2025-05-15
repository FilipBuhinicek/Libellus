class BorrowingsController < ApplicationController
  before_action :authenticate_request
  before_action :load_borrowings, only: [ :index ]
  before_action :load_borrowing, only: [ :show, :update, :destroy ]
  before_action :authorize_resource, only: [ :show, :update, :destroy ]
  before_action :authorize_class, only: [ :index ]

  def index
    render json: @borrowings
  end

  def show
    render json: @borrowing
  end

  def create
    borrowing = Borrowing.new(borrowing_params)

    authorize borrowing

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
end
