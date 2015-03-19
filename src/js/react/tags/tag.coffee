React = require 'react'

{ div } = React.DOM

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

  onDragEnd: (event) ->
    dropTarget = findDropTarget '[data-hveid]', { x: event.clientX, y: event.clientY }
    if dropTarget
      targetData = @props.helpers.getTargetData?( dropTarget )
      @props.actions?.assignTag?( targetData, @props.tag, dropTarget )

  render: ->
    div {
      draggable: true
      onDragStart: @onDragStart
      onDragEnd: @onDragEnd
      style:
        padding: "1px 4px"
        borderRadius: 4
        border: "1px solid #{@props.tag.color}"
        backgroundColor: @props.tag.color
        marginRight: 8
    },
      div {}, @props.tag.name

module.exports = Tag
