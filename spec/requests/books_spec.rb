require 'rails_helper'

RSpec.describe "Books", type: :request do
  let(:librarian) { create(:librarian) }
  let(:headers) { auth_headers_for(librarian) }
  let(:response_data) { JSON.parse(response.body)['data'] }
  let(:response_body) { JSON.parse(response.body) }

  describe "GET /index" do
    it "returns list of books" do
      create_list(:book, 2)

      get "/books", headers: headers

      expect(response).to have_http_status(:success)
      expect(response_data).to be_an(Array)
      expect(response_data.count).to eq(2)
    end
  end

  describe "GET /show" do
    it "returns book" do
      book = create(:book)

      get "/books/#{book.id}", headers: headers

      expect(response).to have_http_status(:success)
      expect(response_data).to be_a(Hash)
      expect(response_data["id"]).to eq(book.id.to_s)
    end
  end

  describe "POST /create" do
    it "creates a new book" do
      author = create(:author)
      book_params = {
        book: {
          title: "Judita",
          published_year: 1521,
          description: "Ep o osloboditeljici naroda, djelo Marka Marulića.",
          book_type: "historical",
          copies_available: 3,
          author_id: author.id
        }
      }

      expect { post "/books", params: book_params.to_json, headers: headers
      }.to change { Book.count }.by(1)

      expect(response).to have_http_status(:created)
      expect(response_data["attributes"]["title"]).to eq("Judita")
      expect(response_data["attributes"]["published_year"]).to eq(1521)
      expect(response_data["attributes"]["description"]).to eq("Ep o osloboditeljici naroda, djelo Marka Marulića.")
      expect(response_data["attributes"]["book_type"]).to eq("historical")
      expect(response_data["attributes"]["copies_available"]).to eq(3)
      expect(response_data["relationships"]["author"]["data"]["id"]).to eq(author.id.to_s)
    end
  end

  describe "PATCH /update" do
    let(:author) { create(:author) }
    let(:book) do
      create(:book, title: "OldTitle", published_year: 1001, description: 'OldDescription', book_type: 'romance', author: author)
    end
    context "with valid params" do
      let(:valid_params) do
        {
          book: {
            title: "Judita",
            published_year: 1521,
            description: "Ep o osloboditeljici naroda, djelo Marka Marulića.",
            book_type: "historical",
            copies_available: 3,
            author_id: author.id
          }
        }
      end

      it "updates the book and returns success" do
        patch "/books/#{book.id}", params: valid_params.to_json, headers: headers

        expect(response).to have_http_status(:success)
        response_data = JSON.parse(response.body)["data"]
        expect(response_data["id"]).to eq(book.id.to_s)
        expect(response_data["attributes"]["title"]).to eq("Judita")
        expect(response_data["attributes"]["published_year"]).to eq(1521)
        expect(response_data["attributes"]["description"]).to eq("Ep o osloboditeljici naroda, djelo Marka Marulića.")
        expect(response_data["attributes"]["book_type"]).to eq("historical")
        expect(response_data["attributes"]["copies_available"]).to eq(3)
        expect(response_data["relationships"]["author"]["data"]["id"]).to eq(author.id.to_s)

        book.reload
        expect(book.title).to eq("Judita")
        expect(book.published_year).to eq(1521)
        expect(book.description).to eq("Ep o osloboditeljici naroda, djelo Marka Marulića.")
      end
    end

    context "with invalid params" do
      let(:invalid_params) do
        {
          book: {
            title: ""
          }
        }
      end

      it "does not update the book and returns errors" do
        patch "/books/#{book.id}", params: invalid_params.to_json, headers: headers

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response_body['title'].first).to eq("can't be blank")
      end
    end
  end

  describe "DELETE /destroy" do
    it "deletes an book" do
      book = create(:book)

      expect {
        delete "/books/#{book.id}", headers: headers
      }.to change { Book.count }.by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end
end
