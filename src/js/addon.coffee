app = require './app'

DOMObserver = require './helpers/domObserver'

addonEntry =
  start: (_taistApi, entryPoint) ->
    window._app = app
    app.api = _taistApi

    app.elems = {}

    app.storage.getTags (tags) ->

      observer = new DOMObserver()
      observer.waitElement '#rcnt', (elem) ->
        app.elems.tagsList = document.createElement 'div'
        elem.appendChild app.elems.tagsList
        require('./react/main').render()

      observer.waitElement '[data-hveid]', (elem) ->
        container = document.createElement 'div'
        container.className = 'taistTags'
        elem.insertBefore container, elem.querySelector 'div'
        targetData = app.helpers.getTargetData elem

        app.storage.getEntity targetData.id, (entity) ->
          if entity
            app.helpers.renredTagsList entity.tags, container

module.exports = addonEntry
