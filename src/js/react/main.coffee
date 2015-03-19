app = require '../app'

React = require 'react'

{ div } = React.DOM

TagsList = require './tags/tagsList'

getElementRect = require './helpers/getElementRect'

GoogleTags = React.createFactory React.createClass
  render: ->
    tagsListRect = getElementRect document.querySelector '.appbar'

    div {
      style:
        position: 'fixed'
        top: tagsListRect.top + 60
        right: '9.6%'
        width: '32%'
        padding: 8
        paddingTop: 7
        fontFamily: 'arial, sans-serif'
        fontSize: 13
    },
      div { style: padding: 4 }, 'Tags by Tai.st'
      div { style: padding: 4 },
        TagsList @props

module.exports =
  render: (container) ->
    renderData = app.helpers.prepareTagListData app.storage.getTagsIds()
    React.render GoogleTags(renderData), container
