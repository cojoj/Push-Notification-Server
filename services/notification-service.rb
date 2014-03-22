# Declaration of NotificationService clas
require 'gcm'
require 'houston'

class NotificationService
  # Instance variables
  attr_accessor :gcm, :apn
  
  def initialize
    # Initializing Google Cloud Messaging
    @gcm = GCM.new("AIzaSyCHfOzDIlO-ewKLFd6LKCAkxwdsOg7f76w")
    
    # Initializing Apple Push Notifications Service
    certificate = File.read("services/PNSck.pem")
    passphrase = "050034frog"
    @apn = Houston::Connection.new(Houston::APPLE_DEVELOPMENT_GATEWAY_URI, certificate, passphrase)
  end
  
  # Sending message to all Android devices
  def send_to_android_devices(devices, message)
    data = {data: {message: message}}
    @gcm.send_notification(android_devices.map(&:id), data)
  end
  
  # Sending message to all iOS devices
  def send_to_ios_devices(devices, message)
    # Opening connection
    @apn.open
    
    # Sending to each device
    devices.each do |device|
      notification = Houston::Notification.new(device: device.id)
      notification.alert = message
      @apn.write(notification.message)
    end
    
    # Closing connection
    @apn.close
  end
end

