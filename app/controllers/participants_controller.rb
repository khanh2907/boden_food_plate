class ParticipantsController < ApplicationController
  before_filter :authenticate_user!
  # after_action :verify_authorized

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
    @participant = Participant.create(secure_params)
    redirect_to participants_path, :notice => "Participant successfully created."
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
    params.require(:participant).permit(:pid, :gender, :date_of_birth, :group)
  end

end
