app = require './app'

DOMObserver = require './helpers/domObserver'

addonEntry =
  start: (_taistApi, entryPoint) ->
    window._app = app
    app.api = _taistApi

    app.elems = {}

    observer = new DOMObserver()
    observer.waitElement '#rcnt', (elem) ->
      app.elems.tagsList = document.createElement 'div'
      elem.appendChild app.elems.tagsList
      require('./react/main').render app.elems.tagsList

    observer.waitElement '[data-hveid]', (elem) ->
      container = document.createElement 'div'
      container.className = 'taistTags'
      elem.insertBefore container, elem.querySelector 'div'
      targetData = app.helpers.getTargetData elem

      app.storage.getEntity targetData.id, (entity) ->
        if entity
          console.log 'on [data-hveid]', entity
          TagList = require('./react/tags/tagsList')

          data =
            tagsIds: entity.tags
            tagsMap: app.storage.getTagsMap()

            actions: app.actions
            helpers: app.helpers

          React = require 'react'
          React.render ( TagList data ), container



module.exports = addonEntry
