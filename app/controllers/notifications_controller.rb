class NotificationsController < ApplicationController
  before_action :authenticate_request
  before_action :load_notifications, only: [ :index ]
  before_action :load_notification, only: [ :show, :update, :destroy ]

  def index
    render json: @notifications
  end

  def show
    render json: @notification
  end

  def create
    notification = Notification.new(notification_params)

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
end
