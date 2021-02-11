require 'rails_helper'

describe InvitationMailer, type: :mailer do
  describe 'invite' do
    before :each do
      @sending_user = create(:user)
      @friend = create(:user)
          create(:friendship, user: @friend, friend: @sending_user)
      @text = "Hey, #{@friend.name}! #{@sending_user.name} just added you to a new Viewing Party! Please go log into your Viewing Party Dashboard to see more details."
      @email_info = {
        user: @sending_user,
        friend: @friend, 
        message: @text
      }
    end
    
    let(:mail) { InvitationMailer.invite(@sending_user, @friend) }
    
    it 'renders headers' do
      expect(mail.subject).to eq("#{@sending_user.name} has invited you to a Viewing Party!")
      expect(mail.to).to eq([@friend.email])
      expect(mail.from).to eq(['invites@viewingparty.com'])
      expect(mail.reply_to).to eq([@sending_user.email])
    end

    it 'renders body' do
      expect(mail.text_part.body.to_s).to include(@text)
      expect(mail.html_part.body.to_s).to include(@text)
      expect(mail.body.encoded).to include(@text)
    end
  end
end