fs = require 'fs'
path = require 'path'

fs.readdir "~/", (err, list) ->
  if err
    return console.log err

  for file in list
    console.log file
