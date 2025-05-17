require 'rails_helper'

RSpec.describe "Reservations", type: :request do
  let(:member) { create(:member) }
  let(:librarian) { create(:librarian) }
  let(:member_headers) { auth_headers_for(member) }
  let(:librarian_headers) { auth_headers_for(librarian) }
  let(:response_data) { JSON.parse(response.body)["data"] }
  let(:response_body) { JSON.parse(response.body) }

  describe "GET /index" do
    it "returns all reservations for librarian" do
      create_list(:reservation, 2)

      get "/reservations", headers: librarian_headers

      expect(response).to have_http_status(:success)
      expect(response_data).to be_an(Array)
      expect(response_data.count).to eq(2)
    end

    it "returns own reservations for member" do
      create(:reservation, member: create(:member))
      create(:reservation, member: member)

      get "/reservations", headers: member_headers

      expect(response).to have_http_status(:success)
      expect(response_data).to be_an(Array)
      expect(response_data.count).to eq(1)
    end
  end

  describe "GET /show" do
    it "returns reservation to librarian" do
      reservation = create(:reservation)

      get "/reservations/#{reservation.id}", headers: librarian_headers

      expect(response).to have_http_status(:success)
      expect(response_data["id"]).to eq(reservation.id.to_s)
    end

    it "returns own reservation to member" do
      reservation = create(:reservation, member: member)

      get "/reservations/#{reservation.id}", headers: member_headers

      expect(response).to have_http_status(:success)
      expect(response_data["id"]).to eq(reservation.id.to_s)
    end

    it "forbids access to other member's reservation" do
      reservation = create(:reservation, member: create(:member))

      get "/reservations/#{reservation.id}", headers: member_headers

      expect(response).to have_http_status(:forbidden)
    end
  end

  describe "POST /create" do
    it "creates reservation as librarian" do
      book = create(:book)
      reservation_params = {
        reservation: {
          reservation_date: Date.today,
          expiration_date: Date.today + 5.days,
          book_id: book.id,
          user_id: member.id
        }
      }

      expect {
        post "/reservations", params: reservation_params.to_json, headers: librarian_headers
      }.to change { Reservation.count }.by(1)

      expect(response).to have_http_status(:created)
      expect(response_data["attributes"]["reservation_date"]).to eq(Date.today.to_s)
      expect(response_data["attributes"]["expiration_date"]).to eq((Date.today + 5.days).to_s)
    end

    it "creates own reservation as member" do
      book = create(:book)
      reservation_params = {
        reservation: {
          reservation_date: Date.today,
          expiration_date: Date.today + 5.days,
          book_id: book.id,
          user_id: member.id
        }
      }

      expect {
        post "/reservations", params: reservation_params.to_json, headers: member_headers
      }.to change { Reservation.count }.by(1)

      expect(response).to have_http_status(:created)
    end
  end

  describe "PATCH /update" do
    let(:reservation) { create(:reservation, member: member) }

    context "as librarian with valid params" do
      let(:valid_params) do
        {
          reservation: {
            expiration_date: reservation.reservation_date + 10.days
          }
        }
      end

      it "updates reservation" do
        patch "/reservations/#{reservation.id}", params: valid_params.to_json, headers: librarian_headers

        expect(response).to have_http_status(:success)
        expect(response_data["attributes"]["expiration_date"]).to eq((reservation.reservation_date + 10.days).to_s)

        reservation.reload
        expect(reservation.expiration_date).to eq(reservation.reservation_date + 10.days)
      end
    end

    context "as member" do
      let(:update_params) do
        { reservation: { expiration_date: Date.today + 10.days } }
      end

      it "forbids member from updating" do
        patch "/reservations/#{reservation.id}", params: update_params.to_json, headers: member_headers

        expect(response).to have_http_status(:forbidden)
      end
    end

    context "with invalid params" do
      let(:invalid_params) do
        {
          reservation: {
            expiration_date: reservation.reservation_date - 1.day
          }
        }
      end

      it "returns validation error" do
        patch "/reservations/#{reservation.id}", params: invalid_params.to_json, headers: librarian_headers

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response_body["expiration_date"].first).to include("must be after reservation date")
      end
    end
  end

  describe "DELETE /destroy" do
    let!(:reservation) { create(:reservation, member: member) }

    it "deletes reservation as librarian" do
      expect {
        delete "/reservations/#{reservation.id}", headers: librarian_headers
      }.to change { Reservation.count }.by(-1)

      expect(response).to have_http_status(:no_content)
    end

    it "deletes own reservation as member" do
      expect {
        delete "/reservations/#{reservation.id}", headers: member_headers
      }.to change { Reservation.count }.by(-1)

      expect(response).to have_http_status(:no_content)
    end

    it "forbids deletion of others' reservation by member" do
      other_reservation = create(:reservation, member: create(:member))

      delete "/reservations/#{other_reservation.id}", headers: member_headers

      expect(response).to have_http_status(:forbidden)
    end
  end
end
