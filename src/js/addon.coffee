app = require './app'

addonEntry =
  start: (_taistApi, entryPoint) ->
    window._app = app
    app.api = _taistApi

    app.api.wait.elementRender '#rcnt', (parent) ->
      container = document.createElement 'div'
      parent.get(0).appendChild container
      require('./react/main').render container

module.exports = addonEntry
