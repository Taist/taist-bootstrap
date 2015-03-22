app = require './app'

DOMObserver = require './helpers/domObserver'

addonEntry =
  start: (_taistApi, entryPoint) ->
    window._app = app

    app.init _taistApi

    app.storage.getTags().then (tags) ->

      observer = new DOMObserver()

      observer.waitElement '#rhs_block', (elem) ->
        app.elems.tagsList = document.createElement 'div'
        if elem.firstChild
          elem.insertBefore app.elems.tagsList, elem.firstChild
        else
          elem.appendChild app.elems.tagsList
        require('./react/main').render()

      observer.waitElement '[data-hveid]', (elem) ->
        container = document.createElement 'div'
        container.className = 'taistTags'
        elem.insertBefore container, elem.querySelector 'div'
        targetData = app.helpers.getTargetData elem

        app.storage.getEntity targetData.id
        .then (entity) ->
          if entity
            app.helpers.renredTagsList {
              entityId: entity.id
              tags: entity.tags
            }, container

module.exports = addonEntry
