class BooksController < ApplicationController
  before_action :authenticate_request
  before_action :load_books, only: [ :index ]
  before_action :load_book, only: [ :show, :update, :destroy ]

  def index
    render json: @books
  end

  def show
    render json: @book
  end

  def create
    book = Book.new(book_params)

    if book.save
      render json: book, status: :created
    else
      render json: book.errors, status: :unprocessable_entity
    end
  end

  def update
    if @book.update(book_params)
      render json: @book
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
    @books = Book.all
  end

  def load_book
    @book = Book.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Book not found" }, status: :not_found
  end

  def book_params
    params.require(:book).permit(:title, :published_year, :description, :book_type, :copies_available, :author_id)
  end
end
