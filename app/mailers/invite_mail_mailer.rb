class InviteMailMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.invite_mail_mailer.invite.subject
  #
  def invite(user)
    @user = user
    @land = user.lands.select(:slug).first

    mail(
      to: user.email,
      subject: 'Đất của bạn đang rao ở đây'
    )
  end
end
