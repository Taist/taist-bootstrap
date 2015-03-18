React = require 'react'

{ div } = React.DOM

Tag = React.createFactory React.createClass
  render: ->
    div {
      style:
        padding: "2px 6px"
        borderRadius: 4
        border: "1px solid #{@props.tag.color}"
        backgroundColor: @props.tag.color
        marginRight: 8
    },
      div {}, @props.tag.name

module.exports = Tag
