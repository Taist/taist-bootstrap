React = require 'react'

{ div, a } = React.DOM

TagsIndex = React.createFactory React.createClass
  render: ->
    div {
      style:
        marginTop: 12
    }, @props.index.map (entity) ->
      div { key: entity.id, style: marginBottom: 4 },
        a { href: entity.id }, entity.title

module.exports = TagsIndex
