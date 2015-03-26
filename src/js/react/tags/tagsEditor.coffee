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

  onKeyDown: (event) ->
    switch event.key
      when 'Enter' then @onSave()
      when 'Escape' then @onCancel()

  render: ->
    div {
      style:
        marginTop: 12
    },
      div {},
        input {
          onKeyDown: @onKeyDown
          ref: 'tagName'
          type: 'text'
          placeholder: 'Create new tag'
          style:
            border: '1px solid silver'
            height: 18
            paddingLeft: 4
        }

module.exports = TagsEditor
