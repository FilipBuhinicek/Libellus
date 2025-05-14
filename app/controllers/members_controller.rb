class MembersController < ApplicationController
  before_action :authenticate_request, only: [ :index, :show, :update, :destroy ]
  before_action :load_members, only: [ :index ]
  before_action :load_member, only: [ :show, :update, :destroy ]
  before_action :authorize_resource, only: [ :show, :update, :destroy ]
  before_action :authorize_class, only: [ :index ]

  def index
    render json: @members
  end

  def show
    render json: @member
  end

  def create
    member = Member.new(member_params)

    authorize member

    if member.save
      token = encode_token(user_id: member.id)
      render json: { token: token, member: member }, status: :created
    else
      render json: member.errors, status: :unprocessable_entity
    end
  end

  def update
    if @member.update(member_params)
      render json: @member
    else
      render json: @member.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @member.destroy
    head :no_content
  end

  private

  def load_members
    @members = policy_scope(Member)
  end

  def load_member
    @member = Member.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Member not found" }, status: :not_found
  end

  def member_params
    params.require(:member).permit(
      :first_name, :last_name, :email, :password, :password_confirmation, :membership_start, :membership_end
      )
  end

  def authorize_resource
    authorize @member
  end

  def authorize_class
    authorize Member
  end
end
