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
  property :os,       String       
end

DataMapper.finalize.auto_upgrade! #auto_migrate! to clear everything

################# REST #################

get '/' do
  @devices = Device.all
  haml :home
end

get '/devices' do
  @devices = Device.all
  haml :devices
end

post '/send' do
  devices_ids = params[:devicesIDs]
  message_content = params[:message]

  @devices = Array.new
  @devices = send_message_to_devices(devices_ids, message_content)
  
  haml :list
end

get '/add' do
  haml :add
end

post '/register' do
  @device = Device.new( :id       => params[:id],
                        :owner    => params[:owner],
                        :os       => params[:os])
  
  if @device.save
    puts "Saving device to database - SUCCESS"
    redirect '/'
  else
    puts"Saving device to database - FAILURE"
    redirect '/'
  end
end


################# Helper methods #################

def send_message_to_devices(ids, message)
  # Creating arrays for different devices 
  android_devices = Array.new
  iOS_devices = Array.new
  
  # Interating through array of devices IDs
  ids.each do |id|
    device = Device.get(id)
    
    # Grouping devices into Arrays
    if device.os == 'Android'
      android_devices << device
    elsif device.os == 'iOS'
      iOS_devices << device
    end
  end
  
  # Sending GCM to all Androids
  gcm = GCM.new(ANDROID_API_KEY)
  data = {data: {message: message} };
  response = gcm.send_notification(android_devices.map(&:id), data)
  # puts response
  
  # Sending APN to all iOSs
  
  # Returning an array of devices to which the push notification was sent
  return android_devices.concat(iOS_devices)
end