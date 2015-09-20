require 'houston'
require 'open-uri'

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

end