class LibrariansController < ApplicationController
  before_action :authenticate_request
  before_action :load_librarians, only: [ :index ]
  before_action :load_librarian, only: [ :show, :update, :destroy ]
  before_action :authorize_resource, only: [ :show, :update, :destroy ]
  before_action :authorize_class, only: [ :index ]

  def index
    render json: LibrarianSerializer.new(@librarians).serializable_hash
  end

  def show
    render json: LibrarianSerializer.new(@librarian).serializable_hash
  end

  def create
    librarian = Librarian.new(librarian_params)

    authorize librarian

    if librarian.save
      token = encode_token(user_id: librarian.id)
      render json: {
        token: token,
        librarian: LibrarianSerializer.new(librarian).serializable_hash
      }, status: :created
    else
      render json: librarian.errors, status: :unprocessable_entity
    end
  end

  def update
    if @librarian.update(librarian_params)
      render json: LibrarianSerializer.new(@librarian).serializable_hash
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
    @librarians = policy_scope(Librarian)
  end

  def load_librarian
    @librarian = Librarian.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Librarian not found" }, status: :not_found
  end

  def librarian_params
    params.require(:librarian).permit(
      :first_name, :last_name, :email, :password, :password_confirmation, :employment_date, :termination_date
    )
  end

  def authorize_resource
    authorize @librarian
  end

  def authorize_class
    authorize Librarian
  end
end
