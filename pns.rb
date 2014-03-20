require 'sinatra'
require 'data_mapper'
require 'dm-core'
require 'dm-migrations'
require 'dm-sqlite-adapter'
require 'gcm'
require 'haml'

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
  
  devicesIDs.each do |id|
    @devices << Device.get(id)
  end
  
  androids = Array.new
  #androids = "["
  
  @devices.each do |device|
    if device.os == 1
      androids << device.id 
    else
      # Handle requests for iOS
    end
  end
  
  puts androids;
  ids = androids.to_json
  puts ids

  api_key = "AIzaSyCHfOzDIlO-ewKLFd6LKCAkxwdsOg7f76w"
  gcm = GCM.new(api_key)
  data = {data: {message: message_content}};
  response = gcm.send_notification(androids, data)
  
  puts response
  
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
