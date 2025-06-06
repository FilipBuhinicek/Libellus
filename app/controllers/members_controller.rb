class MembersController < ApplicationController
  before_action :authenticate_request, only: [ :index, :show, :update, :destroy ]
  before_action :load_members, only: [ :index ]
  before_action :load_member, only: [ :show, :update, :destroy ]
  before_action :authorize_resource, only: [ :show, :update, :destroy ]
  before_action :authorize_class, only: [ :index ]

  def index
    render json: MemberSerializer.new(filtered_members).serializable_hash
  end

  def show
    render json: MemberSerializer.new(@member).serializable_hash
  end

  def create
    member = Member.new(member_params)

    authorize member

    if member.save
      token = encode_token(user_id: member.id)
      render json: {
        token: token,
        member: MemberSerializer.new(member).serializable_hash
      }, status: :created
    else
      render json: member.errors, status: :unprocessable_entity
    end
  end

  def update
    if @member.update(member_params)
      render json: MemberSerializer.new(@member).serializable_hash
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

  def filtered_members
    members = @members

    members = members.where("first_name ILIKE ?", "%#{params[:first_name]}%") if params[:first_name].present?
    members = members.where("last_name ILIKE ?", "%#{params[:last_name]}%") if params[:last_name].present?

    if params[:active] == "true"
      members = members.where("membership_end IS NULL OR membership_end >= ?", Date.today)
    elsif params[:active] == "false"
      members = members.where("membership_end IS NOT NULL AND membership_end < ?", Date.today)
    end

    members
  end
end
