require 'houston'
require 'open-uri'
require 'twilio-ruby'

module NotificationHelper


  def send_notifications(tokens, text)
    apn = Houston::Client.development
    apn.certificate = open(ENV['PUSHCERT_PATH']).read
    tokens.each do |t|
      notification = Houston::Notification.new(device: t)
      notification.alert = text

      apn.push(notification)
    end
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

end