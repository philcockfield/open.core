core = require 'open.client/core'
mvc  = core.mvc

###
A wrapper of the system Combo Box.
###
module.exports = class ComboBox extends mvc.View
  constructor: (properties = {}) -> 
      
      # Setup initial conditions.
      super _.extend properties, tagName:'select', className:@_className('combo_box')
      @items = new ComboBox.ItemsCollection()
      @addProps
        selected: null # Gets or sets the selected item (model).
      @_render = yes
      
      # Syners.
      syncEnabled = => 
          ATTR = 'disabled'
          value = if @enabled() then null else ATTR
          @el.attr ATTR, value
      
      # Wire up events.
      @items.bind 'count', => @render()
      @enabled.onChanged syncEnabled
      
      # Event - Selection Change.
      @selected.onReading (e) => 
          e.value =  @items.find (item) -> item.selected?() is yes
      
      @selected.onChanging (e) => 
          # The 'selected' value has changed.  
          # Get the item that is about to be selected.
          item = e.newValue
          if _.isNumber(item)
            # An index was passed in, convert it to a model.
            item = @items.models[item]
          
          if item?
            # Make sure the new item is selected.
            item.selected? true   
          else
            # Null was passed in, de-select the existing selection.
            @selected()?.selected false
      
      @items.bind 'change:selected', (e) => 
          # Unselect other items.
          unselectOthers @, e if e.selected?() is yes
      
      # Event - <select>.onchange
      @el.change (e) => 
          selectedEl = @$('option:selected')
          return if selectedEl.length is 0
          cid = selectedEl.data 'cid'
          item = @items.find (o) -> o.cid is cid
          item?.selected true
      
      # Finish up.
      syncEnabled()
  
  ###
  Retrieve the item model at the given index.
  @param index: The index of the item to retrieve.
  ###
  item: (index) -> @items.models[index]
  
  
  render: -> 
      # Setup initial conditions.
      return unless @_render is yes
      el = @el
      el.empty()
      
      # Insert each <option>.
      @items.each (item) -> 
          label = item.label?() ? ''
          value = item.value?() ? ''
          value = "value=\"#{value}\""  unless value is ''
          el.append $("<option data-cid=\"#{item.cid}\" #{value}>#{label}</option>")
  
  
  ###
  Initializes a set of items
  @param items: An array of item definitions (see 'add' method for structure).
  @returns the ComboBox instance.
  ###
  init: (items = []) -> 
      @clear()
      items = [items] unless _.isArray(items)
      @add item for item in items
      @
  
  
  ###
  Adds a new item to the list.
  @param item
          Either a model, or object literal with the following property.
          NB: The model should have these implemented as "property-functions":
          
          - label    : The display label for the item.
          - value    : The value of the item (if different from the label).
          - selected : Boolean flag indicating if this the the currently selected item.
  ###
  add: (item = {}) -> 
      
      # Setup initial conditions.
      if _.isString(item)
        item = 
          label:item 
      
      # Get the item model.
      isModel = item.cid?
      model = if isModel then item else new ComboBox.Item(item)
      if @items.length is 0 then model.selected? true
      @items.add model
      
      # Wire up events.
      syncElement = => 
          # Update the attributes.
          el = @_optionEl model
          el.attr 'value', model.value() if model.value?
          el.html model.label() if model.label?
          
          # Update the selected state.
          if model.selected?
            SELECTED_ATTR = 'selected'
            selected = if model.selected() is yes then SELECTED_ATTR else null
            el.attr SELECTED_ATTR, selected
      
      model.bind 'change', syncElement
      
      # Finish up.
      syncElement()
      unselectOthers @, model if model.selected?()
      model
  
  
  ###
  Removes the specified item.
  @param item : The item model (or index of the item) to remove.
  ###
  remove: (item) -> 
      return unless item?
      
      # Remove from the Items collection.
      @items.remove item
      
      # Remove the <option> element.
      # NB: This is removed because the list is re-rendered.
  
  
  # Removes all items.
  clear: -> 
      @_render = no
      @remove item for item in _.clone @items.models
      @_render = yes
      @render()
  
  
  # PRIVATE --------------------------------------------------------------------------
  
  
  ###
  Gets the <option> corresponding the the given model
  @param item: The Item model.
  @returns The <option> element as a jQuery object or null if there is not match.
  ###
  _optionEl: (item) -> 
      return null unless item?
      el = @$ "option[data-cid=\"#{item.cid}\"]"
      if el.length is 0 then null else el


unselectOthers = (view, item) -> 
    view.items.each (o) -> o.selected? false unless o is item


class ComboBox.Item extends mvc.Model
  defaults:
      label: null
      value: null
      selected: false


class ComboBox.ItemsCollection extends mvc.Collection
  model: ComboBox.Item



