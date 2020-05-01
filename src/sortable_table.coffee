#!/usr/bin/env coffee
#


if window?
  deep = window.deep

else
  deep = require('deep')

normal_sort = (spec) ->
  {column, direction} = spec
  (a,b) ->
    [a,b] = [b,a] if direction == 'ascending'
    return 1 if a[column] < b[column]
    return -1 if a[column] > b[column] 
    return 0 


class Sortable_Table

  constructor: (data, @columns) ->
    @data = deep.copy(data)
    @elt = document.create('table')
    @elt.setAttribute('id', @id)
    @elt.setAttribute('class', 'sortable-table')
    @thead = new Table_Header(@table)
    @tbody = new Table_Body(@table)
    @elt.appendChild(@thead.elt)
    @elt.appendChild(@tbody.elt)
    @current_sort =
      column: null
      direction: null

  sort_data: (spec) =>
    console.log("sort_data(#{spec})")
    data = await @data
    data.sort(normal_sort(spec))
    @current_sort = spec
    @update()

  # creates and installs new table element
  update: =>
    # create new <tbody> element from current data
    tbody = new Sortable_Table_Body(this)
    @tbody.elt.replaceWith(tbody.elt)
    @tbody = tbody
    @highlight(@current_sort.column)

  highlight: (key) =>
    for th in @thead.elt.getElementsByClassName('column-heading')
      th.classList.remove('highlight')
    for td in @tbody.elt.getElementsByClassName(key)
      td.classList.add('highlight')

  add_column: (key, spec) =>
    spec.key = key
    @columns[key] = spec

  handle_click: (column) =>
    if @table.current_sort.column == column
      if @table.current_sort.direction == 'ascending'
        direction = 'descending'
      else
        direction = 'ascending'
    else
      direction = @defaults[column].sort_order
    @table.sort_data({column, direction})
    

class Sortable_Table_Header

  constructor: (@table) ->
    @elt = document.createElement('thead')
    @elt.setAttribute('class', 'sortable-table-header')
    @tr = document.createElement('tr')
    @elt.setAttribute('id', 'table-header')
    for key, spec of @table.columns
      th = document.createElement('th')
      classes = spec.classes.concat(['column-heading'])
      th.setAttribute('class', classes.join(' '))
      th.innerText = spec.heading_text
      th.onclick = => @table.controller.handle_click(key)
      th.onmouseover = => th.classList.add('mouseover')
      th.onmouseout = => th.classList.remove('mouseover')
      @tr.appendChild(th)

class Sortable_Table_Body

  constructor: (@table) ->
    @elt = document.createElement('tbody')
    @elt.setAttribute('class', 'sortable-table-body')
    for obj in @table.data
      tr = document.createElement('tr')
      tr.setAttribute('class', 'sortable-table-row')
      for spec in @table.columns
        td = document.createElement('td')
        classes = spec.classes.concat(['column-data'])
        td.addAttribute('class', spec.classes.join(' '))
        td.innerText = obj[spec.key]
        tr.appendChild(td)
      @elt.appendChild(tr)


if window?
  window.Sortable_Table = Sortable_Table

else
  exports.Sortable_Table = Sortable_Table
  
