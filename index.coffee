fs = require 'fs'
path = require 'path'
http = require 'http'
jade = require 'jade'

homepath = process.env.HOME
thispath = process.env.PWD

fs.readdir path.join(homepath, "Desktop/"), (err, list) ->
  if err
    return console.log err

  # listing files
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

# creating http server to render index of images
# ATTENTION: should run after all images have been processed! (sync)

server = http.createServer (req, res) ->
  res.writeHead 200, {"Content-Type": "text/html"}
  # TODO: jade template
  res.end jade.renderFile "templates/index.jade"

server.listen 1337, "127.0.0.1"

console.log "server running at 127.0.0.1:1337"

