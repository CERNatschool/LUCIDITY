require 'uri'

class UserMailer < ActionMailer::Base

  def forgot_password(user, key)
    @user, @key = user, key
	logger.info
	logger.info "FORGOTTEN PASSWORD - email: #{@user.email_address}"
	logger.info
	logger.info "Dear #{@user.name},"
	logger.info
	logger.info "Please paste the link below into your browser. This will let you reset your password."
	logger.info
	#u = URI.parse(url_for(@user))
	#logger.info u.scheme + "://" + u.host + "/DAQMAP" + u.path + "/reset_password_from_email/#{@key}"
	logger.info url_for(@user) + "/reset_password_from_email/#{@key}"
	logger.info
	logger.info "Many thanks, the CERN@school DAQMAP team."
	logger.info
    mail( :subject => "The #{app_name} -- forgotten password",
          :to      => user.email_address )
  end

  def invite(user, key)
    @user, @key = user, key
	logger.info
	logger.info "NEW USER - email #{@user.email_address}"
	logger.info
	logger.info "Dear #{@user.name},"
	logger.info
	logger.info "You have been invited to join the CERN@school DAQMAP!"
	logger.info
	logger.info "Please paste the link below into your browser to accept the invitation:"
	logger.info
	#u = URI.parse(url_for(@user))
	#logger.info u.scheme + "://" + u.host + "/DAQMAP" + u.path + "/accept_invitation_from_email/#{@key}"
	logger.info url_for(@user) + "/accept_invitation_from_email/#{@key}"
	logger.info
	logger.info "Many thanks, the CERN@school DAQMAP team."
	logger.info
    mail( :subject => "Invitation to the #{app_name}",
          :to      => user.email_address )
  end

end
