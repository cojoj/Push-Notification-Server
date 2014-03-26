Push-Notification-Server
========================
This is a simple server for sending **push notification** to Andoid and iOS devices. It's packed into clear web application form to provide straightforward usage. You have to remeber that this one is running with dedicated apps so if you want to use it with yours please configure sorce code first.

How to use:
------------------
To use **PNS** you have to install dependencies. If you are using `bunder` just navigate to home directory and run `bundle install`. If not, all dependencis ale stored inside `Gemfile`.

If you have all dependencies installed and modified sorce code for your purposes you fire up `WEBricks` using `ruby pns.rb` in home directory. By default app will launch on port **4567** so you can start using web app by visiting [`localhost`](http://localhost:4567).

Where is the client for this?
------------------
**PNS** was built to work with both iOS and Android and simple apps for this purpose were also made and you can find them:
+ [iOS](https://github.com/cojoj/PNS-iOS)
+ [Android]()

3'rd paty libraries used in PNS
-------------------
+ [Sinatra](https://github.com/sinatra/sinatra)
+ [DataMapper](https://github.com/datamapper)
+ [HAML](https://github.com/haml/haml)
+ [GCM](https://github.com/spacialdb/gcm)
+ [Houston](https://github.com/nomad/houston)
+ [Twitter Bootstrap](https://github.com/twbs/bootstrap)
