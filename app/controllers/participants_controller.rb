class ParticipantsController < ApplicationController
  before_filter :authenticate_user!
  # after_action :verify_authorized

  # TODO: authorization
  # TODO: scope this model to devise -> invite_token?
  # TODO: Interface for participants -> seperated from the admin interface


  respond_to :html, :json

  def index
    @participants = Participant.all
    respond_with(@participants)
  end

  def show
    @participant = Participant.find(params[:id])
    respond_with(@participant)
  end

  def new
    @participant = Participant.new
    respond_with(@participant)
  end

  def create
    @participant = Participant.new(secure_params)
    @participant.password = SecureRandom.base64(69)
    @participant.save
    @participant.send_reset_password_instructions
    redirect_to participants_path, :notice => "Participant successfully created. An invitation email has been sent to #{@participant.email}."
  end

  def edit
    @participant = Participant.find(params[:id])
  end

  def update
    @participant = Participant.find(params[:id])
    if @participant.update_attributes(secure_params)
      redirect_to participants_path, :notice => "Participant updated."
    else
      redirect_to participants_path, :alert => "Unable to update participant."
    end
  end

  def destroy
    participant = Participant.find(params[:id])
    participant.destroy
    redirect_to users_path, :notice => "Participant deleted."
  end

  private

  def secure_params
    params.require(:participant).permit(:pid, :gender, :date_of_birth, :group, :email)
  end

end
