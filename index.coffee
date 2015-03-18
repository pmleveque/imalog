fs = require 'fs'
path = require 'path'
http = require 'http'
jade = require 'jade'

homepath = process.env.HOME
thispath = process.env.PWD

fs.readdir path.join(homepath, "Desktop/"), (err, list) ->
  if err
    return console.log err

  # moving screen shot images from desktop to shots/
  for file in list
    if file.match /^Screen.Shot.*\d{4}-\d{2}-\d{2}/
      extension = path.extname file
      timestamp = (file.match /(\d{4}-\d{2}-\d{2})/)[0]
      oldpath = path.join homepath, "Desktop/", file
      newpath = path.join thispath,
        "shots/",
        "#{timestamp}shot#{Date.now()}#{extension}"
      fs.rename oldpath, newpath, (err) ->
        return console.log err

# Fetching list of screen shot images
imgFetch = () ->
  urls = fs.readdirSync path.join(thispath, "shots/")
  urls.filter (url) -> url.match /png$/

# creating http server to render index of images
# ATTENTION: should run after all images have been processed! (sync)
server = http.createServer (req, res) ->
  if req.url.match /^\/shots\//
    res.writeHead 200, {"Content-Type": "image/png"}
    res.end fs.readFileSync path.join thispath, req.url
  else if req.url == "/"
    res.writeHead 200, {"Content-Type": "text/html"}
    # @todo jade template
    res.end jade.renderFile "templates/index.jade", {"imgUrls": imgFetch()}
  else
    res.writeHead 404
    res.end "not found"

server.listen 1337, "127.0.0.1"
console.log "server running at 127.0.0.1:1337"

