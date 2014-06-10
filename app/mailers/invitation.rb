class Invitation < ActionMailer::Base
  default from: 'notifications@example.com'

  def invitation_email(invitation)
    @invitation = invitation
    @url  = 'http://example.com/login'
    mail(to: @invitation.email, subject: 'Welcome to My Awesome Site')
  end

end
