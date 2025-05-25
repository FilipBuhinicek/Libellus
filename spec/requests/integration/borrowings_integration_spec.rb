require 'rails_helper'

# This integration spec verifies the full flow of creating a book and borrowing it.
# It covers the following steps:
# 1. A librarian creates an author.
# 2. A librarian creates a book.
# 3. A Member borrows the book
# 4. Get the new Borrowing
#
RSpec.describe 'Borrowings Integration', type: :request do
  let!(:librarian) { create(:librarian, id: 1) }
  let(:librarian_headers) { auth_headers_for(librarian) }

  it 'creates author, book, borrowing and returns correct borrowing' do
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

    # Creating a Borrowing
    borrowing_params = {
      book_id: book_id,
      user_id: member.id,
      borrow_date: Date.today,
      due_date: Date.today + 30.days
    }

    post '/borrowings', params: borrowing_params.to_json, headers: librarian_headers
    expect(response).to have_http_status(:created)

    # Fetching borrowing for member
    get '/borrowings', headers: member_headers
    expect(response).to have_http_status(:ok)

    borrowings = JSON.parse(response.body)['data']
    expect(borrowings.size).to eq(1)

    borrowing_notification_id = borrowings.first['id'].to_i

    expect(borrowing_notification_id).to eq(Borrowing.last.id)
    expect(Borrowing.last.member).to eq(member)
  end
end
