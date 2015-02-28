class ParticipantsController < ApplicationController
  before_filter :authenticate_user!
  after_action :verify_authorized

  respond_to :html, :json

  def index
    @participants = Participant.all
    authorize Participant
    respond_with(@participants)
  end

  def show
    @participant = Participant.find(params[:id])
    authorize @participant
    respond_with(@participant)
  end

  def new
    @participant = Participant.new
    authorize @participant
    respond_with(@participant)
  end

  def create
    @participant = Participant.new(secure_params)
    @participant.password = SecureRandom.base64(69)
    @participant.save
    authorize @participant

    unless @participant.email.blank?
      @participant.send_reset_password_instructions
      redirect_to participants_path, :notice => "Participant successfully created. An invitation email has been sent to #{@participant.email}."
    else
      redirect_to participants_path, :notice => "Participant successfully created. (The invitation email was not sent because no email address was specified."
    end
  end

  def edit
    @participant = Participant.find(params[:id])
    authorize @participant
  end

  def update
    @participant = Participant.find(params[:id])
    authorize @participant
    if @participant.update_attributes(secure_params)
      redirect_to participants_path, :notice => "Participant updated."
    else
      redirect_to participants_path, :alert => "Unable to update participant."
    end
  end

  def destroy
    participant = Participant.find(params[:id])
    authorize participant
    participant.destroy
    redirect_to users_path, :notice => "Participant deleted."
  end

  def resend_invite
    @participant = Participant.find(params[:id])
    authorize @participant
    if @participant
      if !@participant.email.blank?
        @participant.send_reset_password_instructions
        redirect_to participants_path, :notice => "An invitation email has been sent to #{@participant.email}."
      else
        redirect_to participants_path, :alert => "Participant #{@participant.pid} does not have an email address. Please set an email for this participant and try again."
      end
    else
      redirect_to participants_path, :alert => "Unable to find participant with id #{params[:id]}."
    end
  end

  private

  def secure_params
    params.require(:participant).permit(:pid, :gender, :date_of_birth, :group, :email)
  end

end
