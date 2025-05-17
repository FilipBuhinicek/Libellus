require 'rails_helper'

RSpec.describe "Librarians", type: :request do
  let(:librarian) { create(:librarian) }
  let(:other_librarian) { create(:librarian) }
  let(:member) { create(:member) }

  let(:librarian_headers) { auth_headers_for(librarian) }
  let(:other_librarian_headers) { auth_headers_for(other_librarian) }
  let(:member_headers) { auth_headers_for(member) }

  let(:response_data) { JSON.parse(response.body)["data"] }
  let(:create_response_data) { JSON.parse(response.body)["librarian"]["data"] }

  describe "GET /librarians" do
    it "allows access for librarians" do
      create_list(:librarian, 2)

      get "/librarians", headers: librarian_headers

      expect(response).to have_http_status(:success)
      expect(response_data).to be_an(Array)
      expect(response_data.count).to eq(3)
    end

    it "forbids access for members" do
      get "/librarians", headers: member_headers

      expect(response).to have_http_status(:forbidden)
    end
  end

  describe "GET /librarians/:id" do
    it "allows librarians to view a librarian" do
      get "/librarians/#{other_librarian.id}", headers: librarian_headers

      expect(response).to have_http_status(:success)
      expect(response_data).to be_a(Hash)
      expect(response_data["id"]).to eq(other_librarian.id.to_s)
    end

    it "forbids members from viewing a librarian" do
      get "/librarians/#{librarian.id}", headers: member_headers

      expect(response).to have_http_status(:forbidden)
    end
  end

  describe "POST /librarians" do
    let(:librarian_params) do
      {
        librarian: {
          first_name: "Ana",
          last_name: "Anic",
          email: "ana@example.com",
          password: "password",
          employment_date: Date.today
        }
      }
    end

    it "allows librarian to create new librarian" do
      post "/librarians", params: librarian_params.to_json, headers: librarian_headers

      expect(response).to have_http_status(:created)
      expect(create_response_data["attributes"]["email"]).to eq("ana@example.com")
    end

    it "forbids member from creating librarian" do
      post "/librarians", params: librarian_params.to_json, headers: member_headers

      expect(response).to have_http_status(:forbidden)
    end
  end

  describe "PATCH /librarians/:id" do
    it "allows librarian to update themselves" do
      patch "/librarians/#{librarian.id}",
            params: { librarian: { last_name: "Novak" } }.to_json,
            headers: librarian_headers

      expect(response).to have_http_status(:ok)
      expect(response_data["attributes"]["last_name"]).to eq("Novak")
    end

    it "forbids other librarian from updating others" do
      patch "/librarians/#{other_librarian.id}",
            params: { librarian: { last_name: "Zabranjeno" } }.to_json,
            headers: librarian_headers

      expect(response).to have_http_status(:forbidden)
    end

    it "forbids member from updating anyone" do
      patch "/librarians/#{librarian.id}",
            params: { librarian: { last_name: "Test" } }.to_json,
            headers: member_headers

      expect(response).to have_http_status(:forbidden)
    end
  end

  describe "DELETE /librarians/:id" do
    it "allows librarian to delete a librarian" do
      delete "/librarians/#{other_librarian.id}", headers: librarian_headers

      expect(response).to have_http_status(:no_content)
    end

    it "forbids member from deleting librarian" do
      delete "/librarians/#{librarian.id}", headers: member_headers

      expect(response).to have_http_status(:forbidden)
    end
  end
end
