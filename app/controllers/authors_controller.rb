class AuthorsController < ApplicationController
  before_action :authenticate_request
  before_action :load_authors, only: [ :index ]
  before_action :load_author, only: [ :show, :update, :destroy ]
  before_action :authorize_resource, only: [ :show, :update, :destroy ]
  before_action :authorize_class, only: [ :index ]

  def index
    render json: AuthorSerializer.new(filtered_authors).serializable_hash
  end

  def show
    render json: AuthorSerializer.new(@author).serializable_hash
  end

  def create
    author = Author.new(author_params)

    authorize author

    if author.save
      render json: AuthorSerializer.new(author).serializable_hash, status: :created
    else
      render json: author.errors, status: :unprocessable_entity
    end
  end

  def update
    if @author.update(author_params)
      render json: AuthorSerializer.new(@author).serializable_hash
    else
      render json: @author.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @author.destroy
    head :no_content
  end

  private

  def load_authors
    @authors = policy_scope(Author)
  end

  def load_author
    @author = Author.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Author not found" }, status: :not_found
  end

  def author_params
    params.require(:author).permit(:first_name, :last_name, :biography)
  end

  def authorize_resource
    authorize @author
  end

  def authorize_class
    authorize Author
  end

  def filtered_authors
    authors = @authors

    authors = authors.where("first_name ILIKE ?", "%#{params[:first_name]}%") if params[:first_name].present?
    authors = authors.where("last_name ILIKE ?", "%#{params[:last_name]}%") if params[:last_name].present?

    authors
  end
end
