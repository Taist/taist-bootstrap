React = require 'react'

{ div, input, button } = React.DOM

Tag = require './tag'
ColorPicker = require '../taist/colorPicker'

TagsEditor = React.createFactory React.createClass
  getInitialState: ->
    tagId: null
    isColorPickerVisible: false
    selectedColor: 'SkyBlue'

  onSave: ->
    tagName = React.findDOMNode(@refs.tagName).value
    if tagName isnt ''
      @props.actions.onSaveTag?( @state.tagId, tagName, @state.selectedColor )
    @onCancel()

  onCancel: ->
    tagName = React.findDOMNode(@refs.tagName).value = ''
    @setState tagId: null, =>
      @props.actions.onSelectTag?( null )

  onDragOver: (event) ->
    event.preventDefault()

  onDrop: (event) ->
    event.preventDefault()
    tagId = event.dataTransfer.getData 'text'
    @setState { tagId, selectedColor: @props.tagsMap[tagId].color }, =>
      React.findDOMNode(@refs.tagName).value = @props.tagsMap[tagId].name
      @props.actions.onSelectTag?( @state.tagId )

  toggleColorPicker: () ->
    @setState isColorPickerVisible: !@state.isColorPickerVisible

  onSelectColor: (color) ->
    @setState selectedColor: color, isColorPickerVisible: false

  render: ->
    div {
      onDragOver: @onDragOver
      onDrop: @onDrop
      style:
        marginTop: 12
    },
      div {},
        input {
          ref: 'tagName'
          type: 'text'
          placeholder: 'Drop tag here'
          style:
            border: '1px solid silver'
            height: 18
            paddingLeft: 4
        }
        div {
          onClick: @toggleColorPicker
          style:
            display: 'inline-block'
            marginLeft: 6
            width: 22
            height: 22
            verticalAlign: 'top'
            overflow: 'hidden'
            backgroundColor: @state.selectedColor
            borderRadius: '50%'
            cursor: 'pointer'
        }
        button {
          onClick: @onSave
          style:
            marginLeft: 6
            height: 22
            width: 60
        }, 'Save'
        button {
          onClick: @onCancel
          style:
            marginLeft: 6
            height: 22
            width: 60
        }, 'Cancel'
      if @state.isColorPickerVisible
        div {},
          ColorPicker { onSelect: @onSelectColor }

module.exports = TagsEditor
