require 'rails_helper'

# This integration spec verifies the full flow of notification creation in the system.
# It covers the following steps:
# 1. A librarian creates two books.
# 2. A new member is created and assigned on a borrowing and reservation
# 3. Upon login, the system triggers the automatic notification check for the member.
# 4. Finally, the spec asserts that:
#    - Two notifications are generated.
#    - One is related to the borrowing.
#    - The other is related to the reservation.
#
RSpec.describe 'Notifications Integration', type: :request do
  let!(:librarian) { create(:librarian, id: 1) }
  let(:librarian_headers) { auth_headers_for(librarian) }

  it 'creates books, borrowing, reservation, and returns correct notifications' do
    author = create(:author)

    book1_params = { title: 'Book One', author: author, copies_available: 4 }
    book2_params = { title: 'Book Two', author: author, copies_available: 2 }

    # Creating 2 books with librarian authentication
    post '/books', params: book1_params.to_json, headers: librarian_headers
    book1_id = JSON.parse(response.body)['data']['id'].to_i

    post '/books', params: book2_params.to_json, headers: librarian_headers
    book2_id = JSON.parse(response.body)['data']['id'].to_i

    member = create(:member, email: "iva@example.com", password: "password", password_confirmation: "password")
    member_headers = auth_headers_for(member)

    _borrowing = create(:borrowing, member: member, book_id: book1_id)
    _reservation = create(:reservation, member: member, book_id: book2_id)

    # After member login, notification chech is triggered and notifications are created
    post '/login', params: { email: "iva@example.com", password: "password" }
    expect(response).to have_http_status(:ok)

    # Fetching notifications for member
    get '/notifications', headers: member_headers
    expect(response).to have_http_status(:ok)

    notifications = JSON.parse(response.body)['data']
    expect(notifications.size).to eq(2)

    borrowing_notification = notifications.find { |n| n['attributes']['title'].include?('borrowing') }
    reservation_notification = notifications.find { |n| n['attributes']['title'].include?('reservation') }

    expect(borrowing_notification).to be_present
    expect(reservation_notification).to be_present
  end
end
