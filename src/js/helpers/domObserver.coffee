class DOMObserver
  bodyObserver: null
  isActive: no
  observers: {}

  constructor: ->
    @bodyObserver = new MutationObserver (mutations) =>
      mutations.forEach (mutation) =>

        for selector, observer of @observers
          if mutation.target.querySelector selector
            if observer.once is yes
              delete @observers[selector]
            observer.action( mutation.target )

  activateMainObserver: ->
    unless @isActive
      @isActive = yes
      target = document.querySelector('body');

      config =
        subtree: true
        childList: true

      @bodyObserver.observe target, config

  waitElementOnce: ( selector, action ) ->
    @activateMainObserver()
    @observers[selector] = { selector, action, once: yes }

module.exports = DOMObserver
