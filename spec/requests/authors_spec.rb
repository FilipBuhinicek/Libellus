require 'rails_helper'

RSpec.describe "Authors", type: :request do
  let(:librarian) { create(:librarian) }
  let(:headers) { auth_headers_for(librarian) }
  let(:response_data) { JSON.parse(response.body)['data'] }
  let(:response_body) { JSON.parse(response.body) }

  describe "GET /index" do
    it "returns list of authors" do
      create_list(:author, 2)

      get "/authors", headers: headers

      expect(response).to have_http_status(:success)
      expect(response_data).to be_an(Array)
      expect(response_data.count).to eq(2)
    end
  end

  describe "GET /show" do
    it "returns author" do
      author = create(:author)

      get "/authors/#{author.id}", headers: headers

      expect(response).to have_http_status(:success)
      expect(response_data).to be_a(Hash)
      expect(response_data["id"]).to eq(author.id.to_s)
    end
  end

  describe "POST /create" do
    it "creates a new author" do
      author_params = {
        author: {
          first_name: "Marko",
          last_name: "Marulic",
          biography: nil
        }
      }

      expect { post "/authors", params: author_params.to_json, headers: headers
      }.to change { Author.count }.by(1)

      expect(response).to have_http_status(:created)
      expect(response_data["attributes"]["first_name"]).to eq("Marko")
      expect(response_data["attributes"]["last_name"]).to eq("Marulic")
      expect(response_data["attributes"]["biography"]).to be_nil
    end
  end

  describe "PATCH /update" do
    let(:author) { create(:author, first_name: "OldName", last_name: "OldLast", biography: nil) }

    context "with valid params" do
      let(:valid_params) do
        {
          author: {
            first_name: "Marko",
            last_name: "Marulic",
            biography: "Updated biography"
          }
        }
      end

      it "updates the author and returns success" do
        patch "/authors/#{author.id}", params: valid_params.to_json, headers: headers

        expect(response).to have_http_status(:success)
        response_data = JSON.parse(response.body)["data"]
        expect(response_data["id"]).to eq(author.id.to_s)
        expect(response_data["attributes"]["first_name"]).to eq("Marko")
        expect(response_data["attributes"]["last_name"]).to eq("Marulic")
        expect(response_data["attributes"]["biography"]).to eq("Updated biography")

        author.reload
        expect(author.first_name).to eq("Marko")
        expect(author.last_name).to eq("Marulic")
        expect(author.biography).to eq("Updated biography")
      end
    end

    context "with invalid params" do
      let(:invalid_params) do
        {
          author: {
            first_name: ""
          }
        }
      end

      it "does not update the author and returns errors" do
        patch "/authors/#{author.id}", params: invalid_params.to_json, headers: headers

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response_body['first_name'].first).to eq("can't be blank")
      end
    end
  end


  describe "DELETE /destroy" do
    it "deletes an author" do
      author = create(:author)

      expect {
        delete "/authors/#{author.id}", headers: headers
      }.to change { Author.count }.by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end
end
