require 'rails_helper'

# This integration spec verifies the full flow of creating a book and reserving it.
# It covers the following steps:
# 1. A librarian creates an author.
# 2. A librarian creates a book.
# 3. A Member reservs the book
# 4. Get the new Reservation
#
RSpec.describe 'Reservation Integration', type: :request do
  let!(:librarian) { create(:librarian, id: 1) }
  let(:librarian_headers) { auth_headers_for(librarian) }

  it 'creates author, book, reservation and returns correct reservation' do
    # Creating author
    author_params = { first_name: "John", last_name: "Doe" }

    post "/authors", params: author_params.to_json, headers: librarian_headers
    expect(response).to have_http_status(:created)

    author_id = JSON.parse(response.body)['data']['id'].to_i

    # Creating of book
    book_params = { title: 'Book', author_id: author_id, copies_available: 4 }

    post '/books', params: book_params.to_json, headers: librarian_headers
    book_id = JSON.parse(response.body)['data']['id'].to_i

    member = create(:member)
    member_headers = auth_headers_for(member)

    # Creating a Reservation
    reservation_params = {
      book_id: book_id,
      user_id: member.id,
      reservation_date: Date.today,
      expiration_date: Date.today + 30.days
    }

    post '/reservations', params: reservation_params.to_json, headers: member_headers
    expect(response).to have_http_status(:created)

    # Fetching reservation for member
    get '/reservations', headers: member_headers
    expect(response).to have_http_status(:ok)

    reservations = JSON.parse(response.body)['data']
    expect(reservations.size).to eq(1)

    reservation_notification_id = reservations.first['id'].to_i

    expect(reservation_notification_id).to eq(Reservation.last.id)
    expect(Reservation.last.member).to eq(member)
  end
end
