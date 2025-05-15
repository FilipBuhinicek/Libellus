class NotificationsController < ApplicationController
  before_action :authenticate_request
  before_action :load_notifications, only: [ :index ]
  before_action :load_notification, only: [ :show, :update, :destroy ]
  before_action :authorize_resource, only: [ :show, :update, :destroy ]
  before_action :authorize_class, only: [ :index, :check_status ]

  def index
    render json: @notifications
  end

  def show
    render json: @notification
  end

  def create
    notification = Notification.new(notification_params)

    authorize notification

    if notification.save
      render json: notification, status: :created
    else
      render json: notification.errors, status: :unprocessable_entity
    end
  end

  def update
    if @notification.update(notification_params)
      render json: @notification
    else
      render json: @notification.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @notification.destroy
    head :no_content
  end

  # Custom akcija
  def check_status
    status_data = []

    current_user.borrowings.includes(book: :author).where("due_date >= ?", Date.today).find_each do |borrowing|
      days_remaining = (borrowing.due_date - Date.today).to_i
      status_data << {
        type: "borrowing",
        days_until_end: days_remaining,
        book_title: borrowing.book.title,
        book_author: borrowing.book.author&.full_name || "Anonymous"
      }
    end

    current_user.reservations.includes(book: :author).where("expiration_date >= ?", Date.today).find_each do |reservation|
      days_remaining = (reservation.expiration_date - Date.today).to_i
      status_data << {
        type: "reservation",
        days_until_end: days_remaining,
        book_title: reservation.book.title,
        book_author: reservation.book.author&.full_name || "Anonymous"
      }
    end

    render json: status_data
  end

  private

  def load_notifications
    @notifications = Notification.all
  end

  def load_notification
    @notification = Notification.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Notification not found" }, status: :not_found
  end

  def notification_params
    params.require(:notification).permit(:title, :content, :sent_date, :user_id)
  end

  def authorize_resource
    authorize @notification
  end

  def authorize_class
    authorize Notification
  end
end
