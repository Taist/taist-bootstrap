React = require 'react'

{ div } = React.DOM

Tag = require './tag'

TagsList = React.createFactory React.createClass
  render: ->
    div {},
      @props.tagsIds.map (tagId) =>
        tag = @props.tagsMap[tagId]
        if tag
          div {
            key: tag.id
            style: display: 'inline-block'
          }, Tag {
            tag: tag
            entityId: @props.entityId
            actions: @props.actions
            helpers: @props.helpers
          }

module.exports = TagsList
