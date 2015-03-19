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

React = require 'react'

app =
  api: null

  actions:
    assignTag: (object, tag, element) ->
      app.storage.getEntity object.id, (savedEntity) ->
        entity = extend({ tags: [] }, savedEntity, object)

        if entity.tags.indexOf tag.id < 0
          entity.tags.push tag.id

        console.log 'assignTag', JSON.stringify entity

        app.storage.setEntity entity, (entity) ->
          app.helpers.renredTagsList entity.tags, element.querySelector '.taistTags'

  helpers:
    renredTagsList: (tags, container) ->
      TagList = require('./react/tags/tagsList')
      renderData = app.helpers.prepareTagListData tags
      React.render ( TagList renderData ), container

    prepareTagListData: (tags) ->
      tagsIds: tags
      tagsMap: app.storage.getTagsMap()
      actions: app.actions
      helpers: app.helpers

    getTargetData: (elem) ->
      link = elem.querySelector 'h3 a'

      id: link.href
      title: link.innerText

  storage:
    setEntity: (entity, callback) ->
      app.api.userData.set entity.id, entity, () ->
        appData.entities[entity.id] = entity
        callback entity

    getEntity: (id, callback) ->
      entity = appData.entities[id] or null
      if entity
        callback entity
      else
        app.api.userData.get id, (error, entity) ->
          callback entity or null 

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
