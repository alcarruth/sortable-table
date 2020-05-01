#!/usr/bin/env coffee
#

{ Package_File } = require('./package_file')
{ JSON_File } = require('./json_file')
deep = require('./deep')

obj1 = {
  a: 8,
  b: { x: 9, y: 8 },
  c: [ 'hello', { j: 1, k: null, l: undefined } ] }

obj2 = {
  a: 8,
  b: { y: 8, z: 2 },
  c: [ 'goodbye', { j: 3, null: 'abc', l: undefined } ] }


spec =
  fname: 'tes.json'
  defalt: 'skeleton.json'


class Test

  constructor: (@spec = spec) ->
    @fname = 'package.json'
    @shadow = 'shadow.json'
    @skeleton = 'skeleton.json'
    
    @obj1 =obj1
    @obj2 =obj2

    { @fname, @defalt } = @spec
    # delete test file if it exists
    if fs.existsSync(@fname)
      fs.unlinkSync(@fname)

  run1: =>
    @pkg_file = new Package_File( fname: @fname, defalt: @skeleton )

  run2: =>
    @obj3 = deep.copy(@obj1)
    @obj4 = deep.shade(@obj1, @obj2)

  run3: =>
    @pf2 = new Package_File( fname: null, defalt: @skeleton )
    @pf2.load()

  run4: =>
    @pf2.apply_shadow_file(@shadow)

todo = """
TODO:

Things to test:
 Package_File
  - bad fname arg
    - not a string
    - non existing file
    - file exists but
      - unreadable
      - readable but not json
  - bad defalt arg
    - not a string
    - non existing file
    - file exists but
      - unreadable
      - readable but not json
  - args ok
    - when to use defalt?
      - when fname fails?
      - when fname succeeds
        - shadow?
 deep.copy
 deep.shadow
 JSON_File
 
  
"""

exports.init = ->

  pf1 = new Package_File('package.json')
  pf1.load()
  pf2 = new Package_File('shadow.json')
  pf2.load()
  pf3 = new Package_File('skeleton.json')
  pf3.load()

  for k,v of {
    Package_File,
    JSON_File,
    deep,
    obj1,
    obj2,
    todo,
    pf1,
    pf2,
    pf3,
    }
    global[k] = v
