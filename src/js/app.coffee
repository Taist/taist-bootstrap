appData =
  tags: [
    { id: 'some-unique-id', name: 'tai.st', color: 'DeepSkyBlue' }
    { id: 'another-unique-id', name: 'react', color: 'SteelBlue' }
  ]

  entities:
    'https://developer.mozilla.org/en-US/docs/Web/API/Node/insertBefore':
      tags: ['some-unique-id']
      id: 'https://developer.mozilla.org/en-US/docs/Web/API/Node/insertBefore'
      title: 'Node.insertBefore() - Web API Interfaces | MDN'

extend = require 'react/lib/Object.assign'

app =
  api: null

  actions:
    assignTag: (object, tag, element) ->
      entity = appData.entities[object.id] or { tags: [] }
      entity = extend({}, appData.entities[object.id] or { tags: [] }, object)
      if entity.tags.indexOf tag.id < 0
        entity.tags.push tag.id

      console.log 'assignTag', JSON.stringify entity
      appData.entities[object.id] = entity

      TagList = require('./react/tags/tagsList')

      renderData =
        tagsIds: entity.tags
        tagsMap: app.storage.getTagsMap()
        actions: app.actions
        helpers: app.helpers

      React = require 'react'
      React.render ( TagList renderData ), element.querySelector '.taistTags'


  helpers:
    getTargetData: (elem) ->
      link = elem.querySelector 'h3 a'

      id: link.href
      title: link.innerText

  storage:
    getEntity: (id) ->
      appData.entities[id] or null

    getTagsArray: ->
      appData.tags

    getTagsIds: ->
      appData.tags.map (tag) -> tag.id

    getTagsMap: ->
      result = {}
      appData.tags.forEach (tag) ->
        result[tag.id] = tag
      result

module.exports = app
