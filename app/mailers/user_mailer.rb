class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: user.email, subject: t("account_activation")
  end

  def password_reset
    @greeting = t("mail.greeting")
    mail to: "to@example.org"
  end
end
