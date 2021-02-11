class PartiesController < ApplicationController
  before_action :require_user

  def new
    @party = Party.new
  end

  def create
    @movie = Movie.find_or_create_by(movie_params)
    @party = Party.new(party_params.merge(movie_id: @movie.id, host_id: current_user.id))
    if @party.save
      send_invites(params[:party][:invitations] - [''])
      flash[:notice] = 'Invitation(s) Sent!'
      redirect_to dashboard_path
    else
      flash[:errors] = @party.errors.full_messages
      render :new, obj: @party
    end
  end

  def send_invites(invitees)
    invitees.each do |invitee|
      @party.invitations.create(party_person_id: invitee)
      InvitationMailer.invite(current_user, User.find(invitee)).deliver_now
    end
  end

  private

  def party_params
    p = params.require(:party).permit(:party_duration, :date, :time)
    p[:party_time] = "#{p.delete(:date)} #{p.delete(:time)}"
    p
  end

  def movie_params
    params.require(:party).permit(:api_ref, :title)
  end
end
