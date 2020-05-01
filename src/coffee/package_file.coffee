#!/usr/bin/env coffee
#

fs = require('fs')
path = require('path')

{ JSON_File } = require('./json_file')
deep = require('./deep')


class Package_File extends JSON_File

  constructor: (fname, defalt = null) ->
    super(fname)
    @defalt = defalt

  load: =>
    if fs.existsSync(@fname)
      super.load(@fname)
    else if @defalt
      super.load(@defalt)
    

exports.Package_File = Package_File
exports.JSON_File = JSON_File
