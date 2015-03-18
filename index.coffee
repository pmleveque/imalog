fs = require 'fs'
path = require 'path'
http = require 'http'
jade = require 'jade'

homepath = process.env.HOME
thispath = process.env.PWD

# Fetching list of screen shot images
imgFetch = () ->
  urls = fs.readdirSync path.join(thispath, "shots/")
  urls.filter (url) -> url.match /png$/

# moving screen shot images from desktop to shots/
moveScreenshots = (callback) ->
  fs.readdir path.join(homepath, "Desktop/"), (err, list) ->
    if err
      return callback(err, null)

    for file in list
      if file.match /^Screen.Shot.*\d{4}-\d{2}-\d{2}/
        extension = path.extname file
        timestamp = (file.match /(\d{4}-\d{2}-\d{2})/)[0]
        oldpath = path.join homepath, "Desktop/", file
        newpath = path.join thispath,
          "shots/",
          "#{timestamp}shot#{Date.now()}#{extension}"
        fs.renameSync oldpath, newpath
        console.log "1 screenshot moved"
    return callback(err, imgFetch())

# creating http server to render index of images
server = http.createServer (req, res) ->
  if req.url.match /^\/shots\//
    res.writeHead 200, {"Content-Type": "image/png"}
    res.end fs.readFileSync path.join thispath, req.url

  else if req.url == "/"
    res.writeHead 200, {"Content-Type": "text/html"}
    moveScreenshots (err, imgUrls) ->
      if err
        return console.log err

      res.end jade.renderFile "templates/index.jade", {"imgUrls": imgUrls}

  else
    res.writeHead 404
    res.end "not found"

server.listen 1337, "127.0.0.1"
console.log "server running at 127.0.0.1:1337"

