React = require 'react'

{ div } = React.DOM

GoogleTags = React.createFactory React.createClass
  render: ->
    div {
      style:
        position: 'absolute'
        top: 0
        right: '9.6%'
        width: '32%'
        padding: 8
        paddingTop: 7
        fontFamily: 'arial, sans-serif'
        fontSize: 13
    },
      div {}, 'Tags by Tai.st'

module.exports =
  render: (container) ->
    data = {}
    React.render GoogleTags(data), container
