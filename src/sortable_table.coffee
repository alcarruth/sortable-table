#!/usr/bin/env coffee
#

deep = require('deep')

if window?
  document = window.document

normal_sort = (spec) ->
  {column, direction} = spec
  (a,b) ->
    [a,b] = [b,a] if direction == 'ascending'
    return 1 if a[column] < b[column]
    return -1 if a[column] > b[column] 
    return 0 

number_sort = (spec) ->
  sort = normal_sort(spec)
  (a,b) ->
    sort(Number(a),Number(b))
  
class Sortable_Table

  constructor: (data, @columns) ->
    @data = deep.copy(data)
    @elt = document.createElement('table')
    @elt.setAttribute('id', @id)
    @elt.setAttribute('class', 'sortable-table')
    @thead = new Sortable_Table_Header(this)
    @tbody = new Sortable_Table_Body(this)
    @elt.appendChild(@thead.elt)
    @elt.appendChild(@tbody.elt)
    @defaults = {}
    for column in @columns
      @defaults[column.key] = column.sort_order
    @current_sort =
      column: null
      direction: null

  sort_data: (spec) =>
    data = await @data
    data.sort(number_sort(spec))
    rank = 1
    for row in data
      row.rank = rank++
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
    className = key.replace(/_/g, '-')
    for th in @thead.elt.getElementsByClassName('column-heading')
      th.classList.remove('highlight')
    for td in @elt.getElementsByClassName(className)
      td.classList.add('highlight')

  add_column: (key, spec) =>
    spec.key = key
    @columns[key] = spec

  handle_click: (column) =>
    defalt_order = @defaults[column]
    if defalt_order != 'none'
      if @current_sort.column == column
        if @current_sort.direction == 'ascending'
          direction = 'descending'
        else
          direction = 'ascending'
      else
        direction = defalt_order
      @sort_data({column, direction})


class Sortable_Table_Header

  constructor: (@table) ->
    @elt = document.createElement('thead')
    @elt.setAttribute('class', 'sortable-table-header')
    @tr = document.createElement('tr')
    @elt.setAttribute('id', 'table-header')
    for column in @table.columns
      th = document.createElement('th')
      classes = column.classes.concat(['column-heading'])
      th.setAttribute('class', classes.join(' '))
      th.innerText = column.heading_text
      th.onclick = ((key)=> => @table.handle_click(key))(column.key)
      if column.key != 'rank'
        th.onmouseover = ((th)-> -> th.classList.add('mouseover'))(th)
        th.onmouseout = ((th)-> -> th.classList.remove('mouseover'))(th)
      @tr.appendChild(th)
    @elt.appendChild(@tr)


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
        td.setAttribute('class', spec.classes.join(' '))
        td.innerText = obj[spec.key]
        tr.appendChild(td)
      @elt.appendChild(tr)


exports.Sortable_Table = Sortable_Table
  
