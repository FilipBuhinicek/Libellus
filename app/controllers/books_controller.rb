class BooksController < ApplicationController
  before_action :authenticate_request
  before_action :load_books, only: [ :index ]
  before_action :load_book, only: [ :show, :update, :destroy ]
  before_action :authorize_resource, only: [ :show, :update, :destroy ]
  before_action :authorize_class, only: [ :index ]

  def index
    render json: BookSerializer.new(filtered_books).serializable_hash
  end

  def show
    render json: BookSerializer.new(@book).serializable_hash
  end

  def create
    book = Book.new(book_params)

    authorize book

    if book.save
      render json: BookSerializer.new(book).serializable_hash, status: :created
    else
      render json: book.errors, status: :unprocessable_entity
    end
  end

  def update
    if @book.update(book_params)
      render json: BookSerializer.new(@book).serializable_hash
    else
      render json: @book.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @book.destroy
    head :no_content
  end

  private

  def load_books
    @books = policy_scope(Book)
  end

  def load_book
    @book = Book.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Book not found" }, status: :not_found
  end

  def book_params
    params.require(:book).permit(:title, :published_year, :description, :book_type, :copies_available, :author_id)
  end

  def authorize_resource
    authorize @book
  end

  def authorize_class
    authorize Book
  end

  def filtered_books
    books = @books

    books = books.where("title ILIKE ?", "%#{params[:title]}%") if params[:title].present?
    books = books.where(published_year: params[:published_year]) if params[:published_year].present?
    books = books.where(book_type: params[:book_type]) if params[:book_type].present?
    books = books.where(author_id: params[:author_id]) if params[:author_id].present?

    if params[:copies_available].present?
      case params[:copies_available]
      when "true"
        books = books.where("copies_available > 0")
      when "false"
        books = books.where(copies_available: 0)
      end
    end

    books
  end
end
