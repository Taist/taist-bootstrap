React = require 'react'

extend = require 'react/lib/Object.assign'
generateUUID = require './helpers/generateUUID'

Q = require 'q'

appData =
  tags: []
  entities: {}
  tagsIndex: {}

app =
  elems: {}
  selectedTagId: null

  api: null
  exapi: {}

  init: (api) ->
    app.api = api

    app.exapi.setUserData = Q.nbind app.api.userData.set, app.api.userData
    app.exapi.getUserData = Q.nbind app.api.userData.get, app.api.userData

    # app.exapi.setPartialUserData = Q.nbind app.api.userData.setPart, app.api.userData

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
      else
        app.storage.getTagsMap()[id].name = name
        app.storage.getTagsMap()[id].color = color

      app.exapi.setUserData 'googleTags', appData.tags
      .then ->
        require('./react/main').render()

    onSelectTag: (id) ->
      app.selectedTagId = id
      require('./react/main').render()

  helpers:
    renredTagsList: (options, container) ->
      TagList = require('./react/tags/tagsList')

      app.helpers.prepareTagListData options.tags
      .then (renderData) ->
        extend renderData, {
          entityId: options.entityId
          actions:
            onDelete: (entityId, tag) ->
              app.actions.deleteTag entityId, tag, container
        }

        React.render ( TagList renderData ), container

    prepareTagListData: (tags) ->
      Q.when if app.selectedTagId then app.storage.prepareTagIndex(app.selectedTagId) else null
      .then (index) ->
        tagsIds: tags
        tagsMap: app.storage.getTagsMap()
        tagIndex: index
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

          tagIndex = app.storage.getTagIndex tag.id
          tagIndex.push { entityId: entity.id, assignDate: Date.now() }

          console.log 'assignTag', JSON.stringify entity

          Q.all [
            app.storage.setEntity entity
            app.exapi.setUserData 'tagsIndex', appData.tagsIndex
            # app.exapi.setPartialUserData 'tagsIndex', tag.id, tagIndex
          ]
          .spread (entity) ->
            Q.resolve entity


    deleteTag: (entityId, tag) ->
      app.storage.getEntity entityId
      .then (entity) ->
        entity.tags.splice entity.tags.indexOf( tag.id ), 1

        tagIndex = app.storage.getTagIndex( tag.id ).filter (index) ->
          index.entityId isnt entity.id
        appData.tagsIndex[tag.id] = tagIndex

        console.log 'deleteTag', JSON.stringify entity

        Q.all [
          app.storage.setEntity entity
          app.exapi.setUserData 'tagsIndex', appData.tagsIndex
        ]
        .spread (entity) ->
          Q.resolve entity

    getTags: () ->
      Q.all [
        app.exapi.getUserData 'googleTags'
        app.exapi.getUserData 'tagsIndex'
      ]
      .spread (tags, tagsIndex) ->
        appData.tags = tags or []
        appData.tagsIndex = tagsIndex or {}
        console.log tags, tagsIndex
        Q.resolve tags

    getTagIndex: (id) ->
      unless appData.tagsIndex[id]
        appData.tagsIndex[id] = []
      appData.tagsIndex[id]

    prepareTagIndex: (id) ->
      indexData = {}
      Q.all app.storage.getTagIndex(id).map (idx) ->
        indexData[idx.entityId] = idx
        app.storage.getEntity(idx.entityId)
      .then (entities) ->
        entities.map (entity) ->
          entity.assignDate = indexData[entity.id].assignDate
          entity

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
