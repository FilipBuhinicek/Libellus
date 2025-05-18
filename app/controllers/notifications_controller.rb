class NotificationsController < ApplicationController
  before_action :authenticate_request
  before_action :load_notifications, only: [ :index ]
  before_action :load_notification, only: [ :show, :update, :destroy ]
  before_action :authorize_resource, only: [ :show, :update, :destroy ]
  before_action :authorize_class, only: [ :index ]

  def index
    render json: NotificationSerializer.new(filtered_notifications).serializable_hash
  end

  def show
    render json: NotificationSerializer.new(@notification).serializable_hash
  end

  def create
    notification = Notification.new(notification_params)

    authorize notification

    if notification.save
      render json: NotificationSerializer.new(notification).serializable_hash, status: :created
    else
      render json: notification.errors, status: :unprocessable_entity
    end
  end

  def update
    if @notification.update(notification_params)
      render json: NotificationSerializer.new(@notification).serializable_hash
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
    @notifications = policy_scope(Notification)
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

  def filtered_notifications
    notifications = @notifications

    notifications = notifications.where(user_id: params[:user_id]) if params[:user_id].present?
    notifications = notifications.where(sent_date: params[:sent_date]) if params[:sent_date].present?

    notifications = notifications.where("sent_date >= ?", params[:from_date]) if params[:from_date].present?
    notifications = notifications.where("sent_date <= ?", params[:to_date]) if params[:to_date].present?

    notifications = notifications.where("title ILIKE ?", "%#{params[:title]}%") if params[:title].present?

    notifications
  end
end
