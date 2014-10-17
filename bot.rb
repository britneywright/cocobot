#! /usr/bin/env ruby

require "bundler/setup"
require 'uri'
require 'cinch'
#require "cinch/plugins/cleverbot"
#require 'mongo'
require 'open-uri'
require 'json'
require './plugins/cleverbot'

# Set the Env
IRC_ENV = ENV["IRC_ENV"] || "development"

$bot = Cinch::Bot.new do
  configure do |c|
    c.server = ENV['IRC_SERVER']
    c.realname = 'Cocobot'
    c.password = ENV['IRC_PASS']

    if IRC_ENV == "development"
      c.channels = ['#cocobot_dev']
      c.user = 'cocobot_dev'
      c.nick = 'cocobot_dev'
    else
      c.channels = [ENV['IRC_CHAN']]
      c.user = ENV['IRC_USER'] || 'cocobot'
      c.nick = ENV['IRC_NICK'] || c.user
    end

    c.plugins.plugins = [Cinch::Plugins::CleverBot]
  end

  on :message, /cocobot say:(.*)/i do |m,message|
    $bot.channels.each do |c|
      c.send(message)
    end
  end

  on :message, /cocobot say (.*):(.*)/i do |m,channel,message|
    $bot.channels.each do |c|
      if c == channel
        c.send(message)
        ret = "Said #{message} on #{c}"
      end
    end
  end

  #
  # Haters Plugin
  #
  on :message, /.*hater(z|s)?.*/i do |m|
    images = [
      "http://i.imgur.com/XaZRf.gif",
      "http://i.imgur.com/imPCK.gif",
      "http://i.imgur.com/kaIiQ.jpg",
      "http://i.imgur.com/B0ehW.gif",
      "http://i.imgur.com/6oPAO.gif",
      "http://i.imgur.com/0X1AK.png",
      "http://i.imgur.com/FPIUh.png",
      "http://i.imgur.com/296IJ.gif",
      "http://i.imgur.com/Kpx68.jpg"
    ]
    m.reply images.sample
  end

  #
  # Cute Plugin
  #
  on :message, /.*cute.*/ do |m|
    images = [
    "http://i.imgur.com/ZCvbDS0.jpg",
    "http://i.imgur.com/CzAUbSh.jpg",
    "http://i.imgur.com/iB005H3.gif",
    "http://i.imgur.com/hDaM9Hw.gif",
    "http://i.imgur.com/EpsifIU.jpg"
      ]
    m.reply images.sample
  end

  #
  # Coffee Plugin
  #
  on :message, /.*coffee.*/ do |m|
    if rand(5) == 0
      message = [
        [:reply, "Hey guys, I like coffee!"],
        [:reply, "Yay!"],
        [:reply, "Coffee!"],
        [:reply, "Coffee? I hope you don't mean Coffeescript! It is a nice option, but don't make it the default."],
        [:action, "smiles"],
        [:action, "is happy"],
        [:action, "dances a *really* fast jig"]
      ]
      msg = message.sample
      if msg.first == :action
        m.channel.action msg.last
      else
        m.reply msg.last
      end
    end
  end

  #
  # Cheer me up Plugin
  #
  on :message, /cheer (.*?) up/i do |m, n|
    images = JSON(open("http://imgur.com/r/aww.json").read)['data']
    image = images[rand(images.length)]
    m.reply "http://i.imgur.com/#{image['hash']}#{image['ext']}"
    unless n == "me" || n == "you"
      m.reply "I hope that makes #{n} feel better"
    end
  end

  #
  # Cray-cray
  #
  on :message, /.*(crazy|cray).*/i do |m|
    m.reply "http://i.imgur.com/hycIuKc.jpg"
  end

  on :message, /.*(whee).*/i do |m|
    message = [
      "http://i.imgur.com/ZwzU3.gif",
      "http://i.imgur.com/QAJlS.gif",
      "http://i.imgur.com/zTIPM.gif",
      "http://i.imgur.com/Ovato.gif",
      "shh, please"
    ]
    m.reply message.sample
  end


  #
  # Is up plugin
  #
 # on :message, /
 # is https?:\/\/(.*?) (up|down)(\?)?/i do |m, domain|
 #   body = open("http://www.isup.me/"+domain).read
 #   if body.include? "It's just you"
 #     m.reply "#{domain} looks UP from here."
 #   elsif body.include? "It's not just you!"
 #     m.reply "#{domain} looks DOWN from here."
 #   else
 #     m.reply  "Not sure, #{domain} returned an error."
 #   end
 # end

  #
  # http status codes
  #
  on :message, /http.(\d\d\d)\b/i do |m, code_str|
    code = Integer code_str
    resp = case code
           when 100
             "Continue"
           when 101
             "Switching Protocols"
           when 102
             "Processing"
           when 200
             "OK"
           when 201
             "Created"
           when 202
             "Accepted"
           when 203
             "Non-Authoritative Information"
           when 204
             "No Content (Won't return a response body)"
           when 205
             "Reset Content (Won't return a response body)"
           when 206
             "Partial Content"
           when 207
             "Multi..Status"
           when 208
             "Already Reported"
           when 226
             "IM Used"
           when 300
             "Multiple Choices"
           when 301
             "Moved Permanently (Will also return this extra header: Location: http://cocobot.com)"
           when 302
             "Found (Will also return this extra header: Location: http://cocobot.com)"
           when 303
             "See Other (Will also return this extra header: Location: http://cocobot.com)"
           when 304
             "Not Modified (Will also return this extra header: Location: http://cocobot.com)"
           when 305
             "Use Proxy (Will also return this extra header: Location: http://cocobot.com)"
           when 306
             "Reserved"
           when 307
             "Temporary Redirect (Will also return this extra header: Location: http://cocobot.com)"
           when 308
             "Permanent Redirect (Will also return this extra header: Location: http://cocobot.com)"
           when 400
             "Bad Request"
           when 401
             "Unauthorized (Will also return this extra header: WWW-Authenticate: Basic realm=\"Fake Realm\""
           when 402
             "Payment Required"
           when 403
             "Forbidden"
           when 404
             "Not Found"
           when 405
             "Method Not Allowed"
           when 406
             "Not Acceptable"
           when 407
             "Proxy Authentication Required (Will also return this extra header: Proxy-Authenticate: Basic realm=\"Fake Realm\")"
           when 408
             "Request Timeout"
           when 409
             "Conflict"
           when 410
             "Gone"
           when 411
             "Length Required"
           when 412
             "Precondition Failed"
           when 413
             "Request Entity Too Large"
           when 414
             "Request-URI Too Long"
           when 415
             "Unsupported Media Type"
           when 416
             "Requested Range Not Satisfiable"
           when 417
             "Expectation Failed"
           when 418
             "I'm a teapot"
           when 420
             "Enhance Your Calm"
           when 422
             "Unprocessable Entity"
           when 423
             "Locked"
           when 424
             "Failed Dependency"
           when 425
             "Reserved for WebDAV advanced collections expired proposal"
           when 426
             "Upgrade Required"
           when 428
             "Precondition Required"
           when 429
             "Too Many Requests"
           when 431
             "Request Header Fields Too Large"
           when 500
             "Internal Server Error"
           when 501
             "Not Implemented"
           when 502
             "Bad Gateway"
           when 503
             "Service Unavailable"
           when 504
             "Gateway Timeout"
           when 505
             "HTTP Version Not Supported"
           when 506
             "Variant Also Negotiates (Experimental)"
           when 507
             "Insufficient Storage"
           when 508
             "Loop Detected"
           when 510
             "Not Extended"
           when 511
             "Network Authentication Required"
           else
             "Unassigned"
           end
    m.reply "HTTP #{code}: #{resp}" if resp
  end
end

$bot.start
