#!/usr/bin/env coffee
#

fs = require('fs')
path = require('path')
deep = require('./deep')

class JSON_File

  constructor: (@fname) ->
    @obj = {}

  save: =>
    @save_json(@obj, @fname)

  load: =>
    @obj = @load_json(@fname)
    
  load_json: (fname = @fname) =>
    if fs.existsSync(fname)
      json = fs.readFileSync(fname, 'utf8')
      obj = JSON.parse(json)
    else
      obj = {}
    return obj  

  save_json: (obj, fname) =>
    json = JSON.stringify(obj, null, 2)
    fs.writeFileSync(fname, json)

  apply_shadow: (obj) =>
    @obj = deep.shade(obj)

  apply_shadow_file: (fname) =>
    obj = @load_json(fname)
    @apply_shadow(obj)
  

exports.JSON_File = JSON_File
