require 'rails_helper'

# This integration spec verifies the full flow of notification creation in the system.
# It covers the following steps:
# 1. A librarian creates two books.
# 2. A new member is created.
# 3. The member performs two actions:
#    - Borrows the first book.
#    - Reserves the second book.
# 4. Upon login, the system triggers the automatic notification check for the member.
# 5. Finally, the spec asserts that:
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

    # Create a member and associated user
    member_params = {
      member: {
        first_name: "Iva",
        last_name: "Ivic",
        email: "iva@example.com",
        password: "password",
        membership_start: Date.today
      }
    }

    headers = {
      'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json'
    }

    post "/members", params: member_params.to_json, headers: headers

    member_id = JSON.parse(response.body)['member']['data']['id'].to_i
    member_headers = auth_headers_for(Member.find(member_id))

    # Member borrows book1
    borrowing_params = {
      book_id: book1_id,
      user_id: member_id,
      borrow_date: Date.today,
      due_date: Date.today + 30.days
    }

    post '/borrowings', params: borrowing_params.to_json, headers: member_headers
    expect(response).to have_http_status(:created)

    # Member reserves book2
    reservation_params = {
      book_id: book2_id,
      user_id: member_id,
      reservation_date: Date.today,
      expiration_date: Date.today + 7.days
    }
    post '/reservations', params: reservation_params.to_json, headers: member_headers
    expect(response).to have_http_status(:created)

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
