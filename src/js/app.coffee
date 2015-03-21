React = require 'react'

extend = require 'react/lib/Object.assign'
generateUUID = require './helpers/generateUUID'

Q = require 'q'


appData =
  tags: []
  entities: {}

app =
  elems: {}

  api: null
  exapi: {}

  init: (api) ->
    app.api = api
    app.exapi.setUserData = Q.nbind app.api.userData.set, app.api.userData
    app.exapi.getUserData = Q.nbind app.api.userData.get, app.api.userData

  actions:
    assignTag: (object, tag, element) ->
      app.storage.assignTag(object, tag)
      .then (entity) ->
        app.helpers.renredTagsList {
          entityId: entity.id
          tags: entity.tags
        }, element.querySelector '.taistTags'

    deleteTag: (entityId, tag, element) ->
      app.storage.deleteTag(entityId, tag)
      .then (entity) ->
        app.helpers.renredTagsList {
          entityId: entity.id
          tags: entity.tags
        }, element

    onSaveTag: (id, name, color = 'SkyBlue') ->
      unless id
        id = generateUUID()
      appData.tags.push { id, name, color }

      app.exapi.setUserData 'googleTags', appData.tags
      .then ->
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
    setEntity: (entity) ->
      app.exapi.setUserData entity.id, entity
      .then () ->
        Q.resolve entity

    getEntity: (id) ->
      Q.when( appData.entities[id] or app.exapi.getUserData id )

    assignTag: (object, tag) ->
      app.storage.getEntity object.id
      .then (savedEntity) ->
        entity = extend({ tags: [] }, savedEntity, object)

        if entity.tags.indexOf(tag.id) < 0
          entity.tags.push tag.id
          console.log 'assignTag', JSON.stringify entity

          app.storage.setEntity entity
          .then (entity) ->
            Q.resolve entity

    deleteTag: (entityId, tag) ->
      app.storage.getEntity entityId
      .then (entity) ->
        entity.tags.splice entity.tags.indexOf(tag.id), 1

        console.log 'deleteTag', JSON.stringify entity
        app.storage.setEntity entity

    getTags: () ->
      app.exapi.getUserData 'googleTags'
      .then (tags) ->
        appData.tags = tags

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
