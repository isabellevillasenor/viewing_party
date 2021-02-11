class PartiesController < ApplicationController
  before_action :require_user

  def new
    @party = Party.new
  end

  def create
    @movie = Movie.find_or_create_by(api_ref: movie.api_ref, title: movie.title)
    @party = Party.new(party_params.merge(movie_id: @movie.id, host_id: current_user.id))
    if @party.save
      headcount = send_invites(params[:party][:friends])
      flash[:notice] = "#{headcount} #{'Invitation'.pluralize(headcount)} Sent!"
      redirect_to dashboard_path
    else
      flash[:errors] = @party.errors.full_messages
      render :new, obj: @party
    end
  end

  def send_invites(invitee_ids)
    invitee_ids.reduce(0) do |count, id|
      @party.invitations.create(party_person_id: id)
      InvitationMailer.invite(current_user, User.find(id)).deliver_now
      count + 1
    end
  end

  private

  def party_params
    p = params.require(:party).permit(:party_duration, :date, :time)
    p[:party_time] = "#{p.delete(:date)} #{p.delete(:time)}"
    p
  end
end
