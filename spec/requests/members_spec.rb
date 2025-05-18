require 'rails_helper'

RSpec.describe "Members", type: :request do
  let(:member) { create(:member) }
  let(:other_member) { create(:member) }
  let(:librarian) { create(:librarian) }
  let(:member_headers) { auth_headers_for(member) }
  let(:librarian_headers) { auth_headers_for(librarian) }
  let(:response_data) { JSON.parse(response.body)["data"] }
  let(:create_response_data) { JSON.parse(response.body)["member"]["data"] }


  describe "GET /members" do
    it "allows librarian to view all members" do
      create_list(:member, 2)
      get "/members", headers: librarian_headers

      expect(response).to have_http_status(:ok)
      expect(response_data).to be_an(Array)
      expect(response_data.count).to eq(2)
    end

    it "forbids member from viewing all members" do
      get "/members", headers: member_headers

      expect(response).to have_http_status(:forbidden)
    end
  end

  describe "GET /members/:id" do
    it "allows librarian to view any member" do
      get "/members/#{member.id}", headers: librarian_headers

      expect(response).to have_http_status(:ok)
      expect(response_data).to be_a(Hash)
    end

    it "allows member to view themselves" do
      get "/members/#{member.id}", headers: member_headers

      expect(response).to have_http_status(:ok)
      expect(response_data).to be_a(Hash)
    end

    it "forbids member from viewing another member" do
      get "/members/#{other_member.id}", headers: member_headers

      expect(response).to have_http_status(:forbidden)
    end
  end

  describe "POST /members" do
    let(:valid_params) do
      {
        member: {
          first_name: "Iva",
          last_name: "Ivic",
          email: "iva@example.com",
          password: "password",
          membership_start: Date.today
        }
      }
    end

    it "allows anyone to create a member" do
      post "/members", params: valid_params.to_json, headers: { "CONTENT_TYPE" => "application/json" }
      expect(response).to have_http_status(:created)

      expect(create_response_data["attributes"]["email"]).to eq("iva@example.com")
    end
  end

  describe "PATCH /members/:id" do
    it "allows member to update themselves" do
      patch "/members/#{member.id}",
            params: { member: { last_name: "Novak" } }.to_json,
            headers: member_headers

      expect(response).to have_http_status(:ok)
      expect(response_data["attributes"]["last_name"]).to eq("Novak")
    end

    it "forbids member from updating another member" do
      patch "/members/#{other_member.id}",
            params: { member: { last_name: "Zabranjeno" } }.to_json,
            headers: member_headers

      expect(response).to have_http_status(:forbidden)
    end

    it "forbids librarian from updating a member" do
      patch "/members/#{member.id}",
            params: { member: { last_name: "Test" } }.to_json,
            headers: librarian_headers

      expect(response).to have_http_status(:forbidden)
    end
  end

  describe "DELETE /members/:id" do
    it "allows librarian to delete a member" do
      delete "/members/#{member.id}", headers: librarian_headers
      expect(response).to have_http_status(:no_content)
    end

    it "allows member to delete themselves" do
      delete "/members/#{member.id}", headers: member_headers
      expect(response).to have_http_status(:no_content)
    end

    it "forbids member from deleting another member" do
      delete "/members/#{other_member.id}", headers: member_headers
      expect(response).to have_http_status(:forbidden)
    end
  end
end
