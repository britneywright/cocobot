# coding: utf-8
#cocobot, based on https://github.com/csexton/radbot
# and https://github.com/asheren/Bot and

#ENV['IRC_SERVER'] = 'irc.freenode.com'
require 'cinch'
require 'open-uri'
require 'json'
require 'pry'
require_relative 'cleverbot'

def reply_random(m, list)
  m.reply list.sample
end

def action_or_reply_response(m, list)
  list = list.sample
    if list.first == :action
      m.channel.action list.last
    else
      m.reply list.last
    end
end

IRC_ENV = ENV["IRC_ENV"] || "development"

bot = Cinch::Bot.new do
  configure do |c|
    c.server = ENV['IRC_SERVER']
    c.realname = 'cocobot'

    if IRC_ENV == "development"
      c.channels = ['#cocobot_dev']
      c.user = 'cocobot_dev'
      c.nick = 'cocobot_dev'
    else
      c.channels=[ENV['IRC_CHAN']]
      c.user = ENV['IRC_USER'] || 'cocobot'
      c.nick = ENV['IRC_NICK'] || c.user
    end
    c.plugins.plugins = [Cinch::Plugins::Cleverbot]
  end

  on :message, /\bh(i|ello)\b/i do |m|
    m.reply "Hello, #{m.user.nick}"
  end

  on :message, /.*weather.*/ do |m|
    open("http://api.wunderground.com/api/d7aa1bd257c65230/geolookup/conditions/q/DC/Washington.json") do |f|
      json_string = f.read
      parsed_json = JSON.parse(json_string)
      location = parsed_json['location']['city']
      temp_f = parsed_json['current_observation']['temp_f']
      weather = parsed_json['current_observation']['weather']
      feelslike_f = parsed_json['current_observation']['feelslike_f']
      m.reply "Current temperature in #{location} is: #{temp_f} F but it feels like #{feelslike_f} F. Conditions are #{weather}.\n"
    end
  end

  on :message, /.*morn.*/ do |m|
    action_or_reply_response m, [
      [:reply, "Mornin' #{m.user.nick}!"],
      [:reply, "need coffee"],
      [:reply, "it's a brand new day!"],
      [:reply, "http://media.scout.com/media/forums/emoticons/168/1269602956_dr-mccoy-and-captain-kirk-approve.gif"],
      [:reply, "http://i.imgur.com/DNO3a.gif"],
      [:reply, "http://media.giphy.com/media/ncXfkKLgn4HOE/giphy.gif"],
      [:action, "yawns"],
      [:reply, "Another day another discussion about editors"],
    ]
  end

  on :message, /#{config.nick}\?/i do |m|
    action_or_reply_response m, [
      [:reply, "Did someone ask for me?"],
      [:reply, "forums.finalgear.com/customavatars/avatar48469_3.gif"],
      [:reply, "what do you want now?"],
      [:reply, "#{m.user.nick}, why are you bothering me?"],
      [:reply, "it wasn't me."],
      [:reply, "yyyyeessss?"],
      [:action, "hides"],
    ]
  end

  on :message, /.*(angr|frustr|annoy).*/i do |m|
    reply_random m, [
      "http://media.giphy.com/media/sO3xw6HuL6yYM/giphy.gif",
      "http://stream1.gifsoup.com/view3/2176641/shirley-temple-angry-o.gif",
      "http://buzzworthy.mtv.com//wp-content/uploads/buzz/2013/10/giphy1.gif",
      "http://25.media.tumblr.com/f9c10ad19d909a351b5bbec90b08064c/tumblr_murtfzl9N81ql5yr7o1_500.gif",
      "http://www.reactiongifs.com/wp-content/uploads/2013/09/so-mad-i-could.gif",
      "http://i.imgur.com/R6qrD.gif",
    ]
  end

  on :message, /.*(cray|craz|whac).*/i do |m|
    reply_random m, [
      "https://p.gr-assets.com/540x540/fit/hostedimages/1380222758/475840.gif",
      "http://www.elmendolotudo.com.ar/wp-content/uploads/funny-gifs-you-so-crazy.gif",
      "http://24.media.tumblr.com/tumblr_l5uggs3ig81qa0khao1_250.gif",
      "http://i.imgur.com/UmpOi.gif",
      "http://media-cache-ak0.pinimg.com/736x/38/94/78/3894782f93c8b79c2176586c6b77f479.jpg",
      "http://www.tikihumor.com/wp-content/uploads/sites/37/2013/09/cray-cray.gif",
    ]
  end

  on :message, /compliment (.+)/i do |m, nick|
    reply_random m, [
      "#{nick}, you're wonderful",
      "#{nick}, you're fantastic",
      "#{nick}, you make me want to be a better bot",
      "#{nick}, your code is legendary",
      "#{nick}, your code is like the things dreams are made of",
      "#{nick}, you're so pretty",
      "http://31.media.tumblr.com/tumblr_mbgemfUDEw1riqizno1_500.gif",
      "http://big.assets.huffingtonpost.com/Ryan1.gif",
    ]
  end

  on :message, /.*(coffee).*/i do |m|
    reply_random m, [
      "https://38.media.tumblr.com/7acba152778efa24e558b92b0f3901fc/tumblr_nbxw8fLhOa1thqrk2o1_500.gif",
      "http://wac.9ebf.edgecastcdn.net/809EBF/ec-origin.chicago.barstoolsports.com/files/2012/12/badcoffee.gif",
      "https://alwaysgotravels.files.wordpress.com/2014/09/really-love-coffee.gif",
      "http://25.media.tumblr.com/57acd60ebc217bc00169fd73b52be5a6/tumblr_mi5u4eeJZv1qcwyxho1_500.gif",
      "http://media.giphy.com/media/mtAU9hD8qdrBC/giphy.gif",
      "COOOFFFEEEEE!",
    ]
  end

  on :message do |m|
    if rand(500) == 0
      reply_random m , [
        "SQUIRREL!",
        "http://i.perezhilton.com/wp-content/uploads/2013/02/teresa-giudice-joe-testimony.gif",
        "Not these guys again...",
        "http://cryptotheque.com/ohai.jpg",
        "http://learn.ractivejs.org/gifs/image.gif",
      ]
    end
  end

  on :message, /\bLOL\b/ do |m|
    reply_random m, [
      "http://i1.kym-cdn.com/entries/icons/original/000/000/025/lol_internet.gif",
      "http://30.media.tumblr.com/tumblr_m2yblxJZ6u1qihztbo1_400.gif",
      "http://1.bp.blogspot.com/-uEcp7CM5z0Y/UngAB-ZCrLI/AAAAAAAAB_s/o_fPwI_5we0/s1600/uncle+buck+gif.gif",
      "http://www.reactiongifs.com/r/thlght.gif",
      "http://www.reactiongifs.com/r/dmtf.gif",
      "http://www.reactiongifs.com/r/bbypss.gif",
      "http://www.reactiongifs.com/r/wbsrfn.gif",
    ]
  end

  on :message, /.*(happy hour).*/i do |m|
    reply_random m, [
      "https://s2.yimg.com/cd/resizer/original/q_8vlP9lIUzJl6eovNuTl9DvmnA.gif",
      "https://s3.yimg.com/cd/resizer/original/1vB1biuZ72DqQmK9yBasF2Ad_Bc.gif",
      "http://www.reactiongifs.com/r/tada.gif",
      "http://media.tumblr.com/b5b4f0688acda5c5682f43c8ba9d932e/tumblr_inline_nczurxJz6k1raprkq.gif",
      "https://i.imgur.com/unFl75C.gif",
    ]
  end

  on :message, /.*(district taco).*/i do |m|
    reply_random m, [
      "http://images5.fanpop.com/image/photos/30300000/Da-best-3-mean-girls-30385685-500-225.gif",
      "http://25.media.tumblr.com/22d830dbc9bd5de756417f2e009e9e65/tumblr_mtbufrOGsO1ql5yr7o1_500.gif",
      "http://bcgavel.com/wp-content/uploads/2013/11/Gilmore-Girls-gif.gif",
    ]
  end

  on :message, /\b(I love|I hate) .*cod.*/i do |m|
    reply_random m, [
      "http://lifeisopinion.ca/content/images/2013/Oct/Sneakers-1.gif",
      "http://leaksource.files.wordpress.com/2013/04/hacker-programming.gif",
    ]
  end

  on :message, /.*hater(s|z).*/i do |m|
    reply_random m, [
      "http://40.media.tumblr.com/908371f7506816c68d09b6fdf07d762e/tumblr_mnlfa851AF1r5gmoeo1_1280.jpg",
      "http://i.imgur.com/Gq3F2.gif",
      "http://images.rapgenius.com/395a3aff21bc706a7d71f46f63695238.480x326x19.gif",
      "http://31.media.tumblr.com/22bb1e6abde94aaee912c7ccdb37b355/tumblr_mrr7qdMDyE1sdl4iqo1_400.gif",
      "https://i.imgur.com/2hJRYfN.gif",
    ]
  end

  on :message, /.*(refactor).*/i do |m|
    reply_random m, [
      "http://www.appliancesonlineblog.com.au/wp-content/uploads/2012/03/coco-from-The-Jetsons.jpg",
      "My software never has bugs. It just develops random features",
      "http://24.media.tumblr.com/83f38af57b95f9f98204409cf1f7c37e/tumblr_mh3es6vGIT1rxnegyo5_500.gif",
      "http://www.reactiongifs.com/r/hllwn.gif",
    ]
  end

#
# HTTP Status Codes
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
             "Moved Permanently"
           when 302
             "Found"
           when 303
             "See Other"
           when 304
             "Not Modified"
           when 305
             "Use Proxy"
           when 306
             "Reserved"
           when 307
             "Temporary Redirect"
           when 308
             "Permanent Redirect"
           when 400
             "Bad Request"
           when 401
             "Unauthorized"
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
             "Proxy Authentication Required"
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
    m.reply "HTTP #{code}: #{resp} - more information https://en.wikipedia.org/wiki/List_of_HTTP_status_codes" if resp
  end
end
bot.start
