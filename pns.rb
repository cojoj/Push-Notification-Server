require 'sinatra'
require 'data_mapper'
require 'dm-core'
require 'dm-migrations'
require 'dm-sqlite-adapter'

DataMapper.setup(:default, 'sqlite:db/pns_db.db')

class Device
  include DataMapper::Resource
  
  property :id, String, key: true, unique: true
  property :owner, String
  property :os, Integer       #1 - Android, 2 - iOS
end
DataMapper.finalize

configure :development do
    DataMapper.auto_upgrade!
end

get '/' do
  @devices = Device.all
  erb :addMessage
end

post '/send' do
  devicesIDs = params[:devicesIDs]
  message = params[:message]

  @devices = Array.new
  
  devicesIDs.each do |id|
    @devices << Device.get(id)
  end
  
  androids = Array.new
  @devices.each do |device|
    if device.os == 1
      androids << device
    else
      # Handle requests for iOS
    end
  end

  erb :list
end

post '/register' do
  @device = Device.new( :id    => params[:device_id],
                        :owner => params[:owner],
                        :os    => params[:os])
  
  if @device.save
    "Saving device to database - SUCCESS"
  else
    "Saving device to database - FAILURE"
  end
end