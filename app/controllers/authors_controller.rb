class AuthorsController < ApplicationController
  before_action :load_authors, only: [ :index ]
  before_action :load_author, only: [ :show, :update, :destroy ]

  def index
    render json: @authors
  end

  def show
    render json: @author
  end

  def create
    author = Author.new(author_params)

    if author.save
      render json: author, status: :created
    else
      render json: author.errors, status: :unprocessable_entity
    end
  end

  def update
    if @author.update(author_params)
      render json: @author
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
    @authors = Author.all
  end

  def load_author
    @author = Author.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Author not found" }, status: :not_found
  end

  def author_params
    params.require(:author).permit(:first_name, :last_name, :biography)
  end
end
