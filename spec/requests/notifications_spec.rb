# spec/requests/notifications_spec.rb

require 'rails_helper'

RSpec.describe "Notifications", type: :request do
  let(:member) { create(:member) }
  let(:librarian) { create(:librarian) }
  let(:member_headers) { auth_headers_for(member) }
  let(:librarian_headers) { auth_headers_for(librarian) }
  let(:response_data) { JSON.parse(response.body)["data"] }
  let(:response_body) { JSON.parse(response.body) }

  describe "GET /notifications" do
    it "returns all notifications for librarian" do
      create_list(:notification, 2)

      get "/notifications", headers: librarian_headers

      expect(response).to have_http_status(:success)
      expect(response_data).to be_an(Array)
      expect(response_data.count).to eq(2)
    end

    it "returns only member's own notifications" do
      create(:notification, member: create(:member))
      create(:notification, member: member)

      get "/notifications", headers: member_headers

      expect(response).to have_http_status(:success)
      expect(response_data).to be_an(Array)
      expect(response_data.count).to eq(1)
    end
  end

  describe "GET /notifications/:id" do
    it "returns notification to librarian" do
      notification = create(:notification)

      get "/notifications/#{notification.id}", headers: librarian_headers

      expect(response).to have_http_status(:success)
      expect(response_data).to be_a(Hash)
      expect(response_data["id"]).to eq(notification.id.to_s)
    end

    it "returns own notification to member" do
      notification = create(:notification, member: member)

      get "/notifications/#{notification.id}", headers: member_headers

      expect(response).to have_http_status(:success)
      expect(response_data).to be_a(Hash)
      expect(response_data["id"]).to eq(notification.id.to_s)
    end

    it "forbids access to other member's notification" do
      notification = create(:notification, member: create(:member))

      get "/notifications/#{notification.id}", headers: member_headers

      expect(response).to have_http_status(:forbidden)
    end
  end

  describe "POST /notifications" do
    let(:valid_params) do
      {
        notification: {
          title: "Reminder",
          content: "Return your books",
          sent_date: Date.today,
          user_id: member.id
        }
      }
    end

    it "creates notification as member for themselves" do
      expect {
        post "/notifications", params: valid_params.to_json, headers: member_headers
      }.to change { Notification.count }.by(1)

      expect(response).to have_http_status(:created)
      expect(response_data["attributes"]["title"]).to eq("Reminder")
      expect(response_data["attributes"]["content"]).to eq("Return your books")
      expect(response_data["attributes"]["sent_date"]).to eq(Date.today.to_s)
      expect(response_data["relationships"]["member"]["data"]["id"]).to eq(member.id.to_s)
    end

    it "forbids creation by librarian" do
      post "/notifications", params: valid_params.to_json, headers: librarian_headers

      expect(response).to have_http_status(:forbidden)
    end
  end

  describe "PATCH /notifications/:id" do
    let(:notification) { create(:notification, member: member) }

    let(:update_params) do
      { notification: { title: "Updated Title" } }
    end

    it "updates notification as librarian" do
      patch "/notifications/#{notification.id}", params: update_params.to_json, headers: librarian_headers

      expect(response).to have_http_status(:success)
      expect(response_data["attributes"]["title"]).to eq("Updated Title")

      notification.reload
      expect(notification.title).to eq("Updated Title")
    end

    it "forbids member from updating notification" do
      patch "/notifications/#{notification.id}", params: update_params.to_json, headers: member_headers

      expect(response).to have_http_status(:forbidden)
    end
  end

  describe "DELETE /notifications/:id" do
    let!(:notification) { create(:notification, member: member) }

    it "deletes notification as librarian" do
      expect {
        delete "/notifications/#{notification.id}", headers: librarian_headers
      }.to change { Notification.count }.by(-1)

      expect(response).to have_http_status(:no_content)
    end

    it "deletes own notification as member" do
      expect {
        delete "/notifications/#{notification.id}", headers: member_headers
      }.to change { Notification.count }.by(-1)

      expect(response).to have_http_status(:no_content)
    end

    it "forbids deletion of others' notifications by member" do
      other_notification = create(:notification, member: create(:member))

      delete "/notifications/#{other_notification.id}", headers: member_headers

      expect(response).to have_http_status(:forbidden)
    end
  end
end
