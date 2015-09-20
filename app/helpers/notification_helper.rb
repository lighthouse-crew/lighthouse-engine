require 'houston'
require 'open-uri'
require 'twilio-ruby'
require 'grocer'
pusher = Grocer.pusher(
  certificate: "/path/to/cert.pem",      # required
  passphrase:  "",                       # optional
  gateway:     "gateway.push.apple.com", # optional; See note below.
  port:        2195,                     # optional
  retries:     3                         # optional
)

module NotificationHelper


  def send_notifications(tokens, text)
    #apn = Houston::Client.development
    #apn.certificate = open(ENV['PUSHCERT_PATH']).read
    pusher = Grocer.pusher(
      certificate: open(ENV['PUSHCERT_PATH']),      # required
      passphrase:  "",                       # optional
      gateway:     "gateway.sandbox.push.apple.com", # optional; See note below.
      port:        2195,                     # optional
      retries:     3                         # optional
    )
    notification = Grocer::Notification.new(
      device_token: "4b3e3a5ec91018c1c4c4191560e132a5b20e5cc60d5479f2d0cb0e173b0ded57",
      alert:             "Hello from Groadfsadfasdfsdfasdfcer!",
      badge:             42,
    )
    puts "#" * 80
    puts pusher.push(notification)
    #tokens.each do |t|
    #  notification = Houston::Notification.new(device: t)
    #  notification.alert = text
#
    #  apn.push(notification)
    #end
  end

  def send_sms_notifications(numbers, text)
    sid = ENV['SID']
    auth_token = ENV['AUTH_TOKEN']
    sending_number = ENV['SENDING_NUMBER']
    client = Twilio::REST::Client.new sid, auth_token
    numbers.each do |n| 
      client.messages.create(
        from: "+#{sending_number}",
        to: "+#{n}",
        body: text
      )
    end
  end

  def generate_message
    
  end

end