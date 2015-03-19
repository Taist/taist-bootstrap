React = require 'react'

{ div } = React.DOM

getElementRect = require '../../helpers/getElementRect'

Tag = React.createFactory React.createClass
  onDragStart: (event) ->

  onDragEnd: (event) ->
    dropX = event.clientX
    dropY = event.clientY

    queryResults = Array.prototype.slice.call(document.querySelectorAll('[data-hveid]'))
    targetResult = queryResults.filter (result) ->
      rect = getElementRect result
      dropTarget = rect.left < ( dropX + window.scrollX ) < ( rect.left + rect.width ) and
        rect.top < ( dropY + window.scrollY ) < ( rect.top + rect.height )
      console.log rect, dropTarget

  render: ->
    div {
      draggable: true
      onDragStart: @onDragStart
      onDragEnd: @onDragEnd
      style:
        padding: "2px 6px"
        borderRadius: 4
        border: "1px solid #{@props.tag.color}"
        backgroundColor: @props.tag.color
        marginRight: 8
    },
      div {}, @props.tag.name

module.exports = Tag
