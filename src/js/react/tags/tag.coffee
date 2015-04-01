React = require 'react'

{ div } = React.DOM

AwesomeIcons = require '../taist/awesomeIcons'

webColors = require '../taist/webColors'

getElementRect = require '../../helpers/getElementRect'

findDropTarget = (selector, coords) ->
  targets = Array.prototype.slice.call(document.querySelectorAll(selector))
  dropTargets = targets.filter (target) ->
    rect = getElementRect target
    dropTarget = rect.left < ( coords.x + window.scrollX ) < ( rect.left + rect.width ) and
      rect.top < ( coords.y + window.scrollY ) < ( rect.top + rect.height )

  dropTargets?[0]

Tag = React.createFactory React.createClass
  onDragStart: (event) ->
    event.dataTransfer.effectAllowed = 'move'
    event.dataTransfer.setData "text", @props.tag.id

  onDragEnd: (event) ->
    dropTarget = findDropTarget '[data-hveid]', { x: event.clientX, y: event.clientY }
    if dropTarget
      targetData = @props.helpers.getTargetData?( dropTarget )
      @props.actions?.assignTag?( targetData, @props.tag, dropTarget )

  onDelete: (event) ->
    @props.actions.onDelete?( @props.entityId, @props.tag )
    event.stopPropagation()

  render: ->
    backgroundColor = @props.tag.color or 'SkyBlue'
    color = if webColors[backgroundColor].isLight then 'black' else 'white'

    div {
      draggable: true
      onDragStart: @onDragStart
      onDragEnd: @onDragEnd
      style:
        padding: '1px 4px'
        borderRadius: 4
        border: "1px solid #{backgroundColor}"
        backgroundColor: backgroundColor
        color: color
        marginRight: 6
        marginBottom: 4
        display: 'inline-block'
    },
      div { style: display: 'inline-block' }, @props.tag.name
      if @props.canBeDeleted
        div {
          onClick: @onDelete
          style:
            display: 'inline-block'
            position: 'relative'
            width: 10
            height: 10
            marginLeft: 2
            cursor: 'pointer'
            backgroundImage: AwesomeIcons.getURL 'remove', color
            backgroundSize: 'contain'
            backgroundRepeat: 'no-repeat'
        }

module.exports = Tag
