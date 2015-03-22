React = require 'react'

{ div, a } = React.DOM

webColors = require './webColors'

colorsArray = ( for name, color of webColors then color )

ColorPicker = React.createFactory React.createClass
  render: ->
    div {
      style:
        marginTop: 12
    }, colorsArray.map (color) =>
      div {
        onClick: => @props.onSelect color.name
        key: color.name
        title: color.name
        style:
          display: 'inline-block'
          marginRight: 4
          width: 14
          height: 14
          overflow: 'hidden'
          backgroundColor: color.name
          borderRadius: '50%'
          cursor: 'pointer'
      }, ''

module.exports = ColorPicker
