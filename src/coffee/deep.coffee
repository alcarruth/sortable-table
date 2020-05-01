Boolean#!/usr/bin/env coffee
#


jump_table =
  
  Object: (x) ->
    y = {}
    for k,v of x
      y[k] = copy(v)
    return y

  Array: (x) ->
    y = []
    for e in x
      y.push(copy(e))
    return y

  String: (x) ->
    return x

  Boolean: (x) ->
    return x

  Number: (x) ->
    return x

  null: (x) ->
    return x

  undefined: (x) ->
    return x


type = (x) ->

  if x in [ null, undefined ]
    return x

  else
    return x.constructor.name



copy = (x) ->
  key = type(x)
  f = jump_table[key]
  return f(x)

shade = (x, y) ->

  x_type = type(x)
  y_type = type(y)

  if x_type != y_type
    if y_type == undefined
      return copy(x)
    if y_type == null
      return null
    
  if x_type == 'Object'
    obj = {}
    for key, val of x
      if y[key] == undefined
        # key only in x
        obj[key] = copy(val)
      else
        # key in both x and y
        obj[key] = shade(val,y[key])
    for key, val of y
      if x[key] == undefined
        obj[key] = copy(val)
    return obj

  if x_type == 'Array'
    array = copy(x)
    for e in y
      if e not in array
        array.push(e)
    return array

  return copy(y)


    
exports.type = type
exports.copy = copy
exports.shade = shade

