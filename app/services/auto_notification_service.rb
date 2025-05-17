class AutoNotificationService
  def self.call(user)
    new(user).generate_notifications
  end

  def initialize(user)
    @user = user
  end

  def generate_notifications
    create_borrowing_notifications
    create_reservation_notifications
  end

  private

  def create_borrowing_notifications
    @user.borrowings.includes(book: :author).where("due_date >= ?", Date.today).find_each do |borrowing|
      days_remaining = (borrowing.due_date - Date.today).to_i
      title = "Book borrowing: #{borrowing.book.title}, Author: #{borrowing.book.author&.full_name || "Unknown"}"

      next if Notification.exists?(user: @user, title: title, created_at: Time.current.all_day)

      Notification.create!(
        user: @user,
        title: title,
        content: "The borrowing expires in #{days_remaining} days.",
        sent_date: Time.current
      )
    end
  end

  def create_reservation_notifications
    @user.reservations.includes(book: :author).where("expiration_date >= ?", Date.today).find_each do |reservation|
      days_remaining = (reservation.expiration_date - Date.today).to_i
      title = "Book reservation: #{reservation.book.title}, Author: #{reservation.book.author&.full_name || "Unknown"}"

      next if Notification.exists?(user: @user, title: title, created_at: Time.current.all_day)

      Notification.create!(
        user: @user,
        title: title,
        content: "The reservation expires in #{days_remaining} days.",
        sent_date: Time.current
      )
    end
  end
end
