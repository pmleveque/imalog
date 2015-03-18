fs = require 'fs'
path = require 'path'

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

