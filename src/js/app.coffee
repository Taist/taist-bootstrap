React = require 'react'

extend = require 'react/lib/Object.assign'
generateUUID = require './helpers/generateUUID'

appData =
  tags: []
  entities: {}

app =
  api: null

  actions:
    assignTag: (object, tag, element) ->
      app.storage.assignTag object, tag, (entity) ->
        app.helpers.renredTagsList {
          entityId: entity.id
          tags: entity.tags
        }, element.querySelector '.taistTags'

    deleteTag: (entityId, tag, element) ->
      app.storage.deleteTag entityId, tag, (entity) ->
        app.helpers.renredTagsList {
          entityId: entity.id
          tags: entity.tags
        }, element

    onSaveTag: (id, name, color = 'SkyBlue') ->
      unless id
        id = generateUUID()
      appData.tags.push { id, name, color }
      app.api.userData.set 'googleTags', appData.tags, ->
        require('./react/main').render()

  helpers:
    renredTagsList: (options, container) ->
      TagList = require('./react/tags/tagsList')

      renderData = app.helpers.prepareTagListData options.tags
      extend renderData, {
        entityId: options.entityId
        actions:
          onDelete: (entityId, tag) ->
            app.actions.deleteTag entityId, tag, container
      }

      React.render ( TagList renderData ), container

    prepareTagListData: (tags) ->
      tagsIds: tags
      tagsMap: app.storage.getTagsMap()
      actions: app.actions
      helpers: app.helpers
      canBeDeleted: true

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

    assignTag: (object, tag, callback) ->
      app.storage.getEntity object.id, (savedEntity) ->
        entity = extend({ tags: [] }, savedEntity, object)

        if entity.tags.indexOf(tag.id) < 0
          entity.tags.push tag.id
          console.log 'assignTag', JSON.stringify entity

          app.storage.setEntity entity, callback

    deleteTag: (entityId, tag, callback) ->
      app.storage.getEntity entityId, (entity) ->
        entity.tags.splice entity.tags.indexOf(tag.id), 1

        console.log 'deleteTag', JSON.stringify entity
        app.storage.setEntity entity, callback

    getTags: (callback) ->
      app.api.userData.get 'googleTags', (error, tags) ->
        appData.tags = tags
        callback tags

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
