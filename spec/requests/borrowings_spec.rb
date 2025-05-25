require 'rails_helper'

RSpec.describe "Borrowings", type: :request do
  let(:member) { create(:member) }
  let(:librarian) { create(:librarian) }
  let(:member_headers) { auth_headers_for(member) }
  let(:librarian_headers) { auth_headers_for(librarian) }
  let(:response_data) { JSON.parse(response.body)["data"] }
  let(:response_body) { JSON.parse(response.body) }

  describe "GET /index" do
    it "returns all borrowings for librarian" do
      create_list(:borrowing, 2)

      get "/borrowings", headers: librarian_headers

      expect(response).to have_http_status(:success)
      expect(response_data).to be_an(Array)
      expect(response_data.count).to eq(2)
    end

  end

  describe "GET /show" do
    it "returns borrowing to librarian" do
      borrowing = create(:borrowing)

      get "/borrowings/#{borrowing.id}", headers: librarian_headers

      expect(response).to have_http_status(:success)
      expect(response_data["id"]).to eq(borrowing.id.to_s)
    end

    it "forbids access to other member's borrowing" do
      borrowing = create(:borrowing, member: create(:member))

      get "/borrowings/#{borrowing.id}", headers: member_headers

      expect(response).to have_http_status(:forbidden)
    end
  end

  describe "POST /create" do
    it "creates borrowing as librarian" do
      book = create(:book)
      borrowing_params = {
        borrowing: {
          borrow_date: Date.today,
          due_date: Date.today + 10.days,
          book_id: book.id,
          user_id: member.id
        }
      }

      expect {
        post "/borrowings", params: borrowing_params.to_json, headers: librarian_headers
      }.to change { Borrowing.count }.by(1)

      expect(response).to have_http_status(:created)
      expect(response_data["attributes"]["borrow_date"]).to eq(Date.today.to_s)
      expect(response_data["attributes"]["due_date"]).to eq((Date.today + 10.days).to_s)
    end

      expect {
        post "/borrowings", params: borrowing_params.to_json, headers: member_headers
      }.to change { Borrowing.count }.by(1)

      expect(response).to have_http_status(:created)
    end
  end

  describe "PATCH /update" do
    let(:borrowing) { create(:borrowing, member: member) }

    context "as librarian with valid params" do
      let(:valid_params) do
        {
          borrowing: {
            due_date: borrowing.borrow_date + 20.days
          }
        }
      end

      it "updates borrowing" do
        patch "/borrowings/#{borrowing.id}", params: valid_params.to_json, headers: librarian_headers

        expect(response).to have_http_status(:success)
        expect(response_data["attributes"]["due_date"]).to eq((borrowing.borrow_date + 20.days).to_s)

        borrowing.reload
        expect(borrowing.due_date).to eq(borrowing.borrow_date + 20.days)
      end
    end

    context "as member" do
      let(:update_params) do
        { borrowing: { return_date: Date.today + 15.days } }
      end

      it "forbids member from updating" do
        patch "/borrowings/#{borrowing.id}", params: update_params.to_json, headers: member_headers

        expect(response).to have_http_status(:forbidden)
      end
    end

    context "with invalid params" do
      let(:invalid_params) do
        {
          borrowing: {
            return_date: borrowing.borrow_date - 1.day
          }
        }
      end

      it "returns validation error" do
        patch "/borrowings/#{borrowing.id}", params: invalid_params.to_json, headers: librarian_headers

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response_body["return_date"].first).to include("must be after borrow date")
      end
    end
  end

  describe "DELETE /destroy" do
    let!(:borrowing) { create(:borrowing, member: member) }

    it "deletes borrowing as librarian" do
      expect {
        delete "/borrowings/#{borrowing.id}", headers: librarian_headers
      }.to change { Borrowing.count }.by(-1)

      expect(response).to have_http_status(:no_content)
    end

    it "forbids deletion of others' borrowing by member" do
      other_borrowing = create(:borrowing, member: create(:member))

      delete "/borrowings/#{other_borrowing.id}", headers: member_headers

      expect(response).to have_http_status(:forbidden)
    end
  end
end
