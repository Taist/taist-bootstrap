app = require './app'

DOMObserver = require './helpers/domObserver'

addonEntry =
  start: (_taistApi, entryPoint) ->
    window._app = app
    app.api = _taistApi

    app.elems = {}

    observer = new DOMObserver()
    observer.waitElementOnce '#rcnt', (parent) ->
      app.elems.tagsList = document.createElement 'div'
      parent.appendChild app.elems.tagsList
      require('./react/main').render app.elems.tagsList

module.exports = addonEntry
