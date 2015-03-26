React = require 'react'

{ div, input, button } = React.DOM

Tag = require './tag'

TagsEditor = React.createFactory React.createClass
  getInitialState: ->
    tagId: null

  onSave: ->
    tagName = React.findDOMNode(@refs.tagName).value
    if tagName isnt ''
      @props.actions.onSaveTag?( @state.tagId, tagName )
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
    @setState { tagId }, =>
      React.findDOMNode(@refs.tagName).value = @props.tagsMap[tagId].name
      @props.actions.onSelectTag?( @state.tagId )

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

module.exports = TagsEditor
