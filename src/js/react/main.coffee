app = require '../app'

React = require 'react'

{ div } = React.DOM

TagsList = require './tags/tagsList'
TagsEditor = require './tags/tagsEditor'
TagIndex = require './tags/tagIndex'

Alert = require './taist/Alert'

getElementRect = require './helpers/getElementRect'
extend = require 'react/lib/Object.assign'

GoogleTags = React.createFactory React.createClass
  render: ->
    tagsListRect = getElementRect document.querySelector '.appbar'

    div {
      style:
        padding: 8
        paddingTop: 7
        fontFamily: 'arial, sans-serif'
        fontSize: 13
    },
      if @props.message
        Alert {
          message: @props.message
          onCancel: @props.onAlertCancel
          onAction: @props.onAlertAction
        }
      div { style: padding: 4 }, 'Tags by Tai.st'
      div { style: padding: 4 },
        TagsList @props
        TagsEditor @props
        if @props.tagIndex
          TagIndex { index: @props.tagIndex }

module.exports =
  render: (options = {}) ->
    app.helpers.prepareTagListData app.storage.getTagsIds()
    .then (renderData) ->
      React.render GoogleTags( extend renderData, options ), app.elems.tagsList
