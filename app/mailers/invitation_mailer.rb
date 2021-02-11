class InvitationMailer < ApplicationMailer
  def invite(user, friend)
    @user = user
    @friend= friend

    mail(
      reply_to: @user.email,
      to: @friend.email,
      subject: "#{@user.name} has invited you to a Viewing Party!"
    )
  end
end