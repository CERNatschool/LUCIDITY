require 'yaml'
amazon_creds = YAML::load(open("#{ENV['PWD']}/config/amazon.yml"))

ActionMailer::Base.add_delivery_method :ses, AWS::SES::Base,
  access_key_id: amazon_creds['access_key_id'],
  secret_access_key: amazon_creds['secret_access_key']
