class LibrariansController < ApplicationController
  before_action :load_librarians, only: [ :index ]
  before_action :load_librarian, only: [ :show, :update, :destroy ]

  def index
    render json: @librarians
  end

  def show
    render json: @librarian
  end

  def create
    librarian = Librarian.new(librarian_params)

    if librarian.save
      render json: librarian, status: :created
    else
      render json: librarian.errors, status: :unprocessable_entity
    end
  end

  def update
    if @librarian.update(librarian_params)
      render json: @librarian
    else
      render json: @librarian.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @librarian.destroy
    head :no_content
  end

  private

  def load_librarians
    @librarians = Librarian.all
  end

  def load_librarian
    @librarian = Librarian.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Librarian not found" }, status: :not_found
  end

  def librarian_params
    params.require(:librarian).permit(
      :first_name, :last_name, :email, :password, :employment_date, :termination_date
      )
  end
end
