class DOMObserver
  bodyObserver: null
  isActive: no
  observers: {}

  processedOnce: []

  constructor: ->
    @bodyObserver = new MutationObserver (mutations) =>
      mutations.forEach (mutation) =>
        for selector, observer of @observers
          nodesList = mutation.target.querySelectorAll selector
          matchedElems = Array.prototype.slice.call nodesList
          matchedElems.forEach (elem) =>
            if elem and @processedOnce.indexOf(elem) < 0
              @processedOnce.push elem
              observer.action elem

  activateMainObserver: ->
    unless @isActive
      @isActive = yes
      target = document.querySelector('body');

      config =
        subtree: true
        childList: true

      @bodyObserver.observe target, config

  waitElement: (selector, action) ->
    @activateMainObserver()
    @observers[selector] = { selector, action }

module.exports = DOMObserver
