require 'sinatra'
require 'data_mapper'
require 'dm-core'
require 'dm-migrations'
require 'dm-sqlite-adapter'
require 'gcm'
require 'haml'

################# Global constants #################

ANDROID_API_KEY = "AIzaSyCHfOzDIlO-ewKLFd6LKCAkxwdsOg7f76w"

################# Database initialization #################

DataMapper.setup(:default, 'sqlite:db/pns_db.db')

class Device
  include DataMapper::Resource
  
  property :id,       String, key: true, unique: true, length: 200
  property :owner,    String
  property :os,       Integer		#1 - Android, 2 - iOS
  property :os_code,  String       
end

DataMapper.finalize.auto_upgrade! #auto_migrate! to clear everything

################# REST #################

get '/' do
  @devices = Device.all
  #erb :addMessage
  haml :blankForm
end

get '/devices' do
  @devices = Device.all
  haml :devices
end

post '/send' do
  devicesIDs = params[:devicesIDs]
  message_content = params[:message]

  @devices = Array.new
  @devices = sendMessageToDevices(devicesIDs, message_content)
  
  erb :list
end

post '/register' do
  @device = Device.new( :id       => params[:id],
                        :owner    => params[:owner],
                        :os       => params[:os],
                        :os_code  => params[:os_code])
                         
  
  if @device.save
    "Saving device to database - SUCCESS"
  else
    "Saving device to database - FAILURE"
  end
end


################# Helper methods #################

def sendMessageToDevices(devicesIDs, message)
  # Creating arrays for different devices 
  androidDevices = Array.new
  iOSDevices = Array.new
  
  # Interating through array of devices IDs
  devicesIDs.each do |id|
    device = Device.get(id)
    
    # Grouping devices into Arrays
    if device.os == 1
      androidDevices << device
    elsif device.os == 2
      iOSDevices << device
    end
  end
  
  # Sending GCM to all Androids
  gcm = GCM.new(ANDROID_API_KEY)
  data = {data: {message: message} };
  response = gcm.send_notification(androidDevices.map(&:id), data)
  # puts response
  
  # Sending APN to all iOSs
  
  # Returning an array of devices to which the push notification was sent
  return androidDevices.concat(iOSDevices)
end