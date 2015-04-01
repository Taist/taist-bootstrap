React = require 'react'

{ div, button } = React.DOM

Alert = React.createFactory React.createClass
  render: ->
    div {
      style:
        position: 'fixed'
        left: 0;
        top: 0;
        width: '100%'
        height: '100%'
        zIndex: 1024
      onClick: (event) -> event.preventDefault()
    },
      div { style:
        width: '100%'
        height: '100%'
        backgroundColor: 'black'
        opacity: 0.6
      }
      div {
        style:
          top: '50%'
          left: '50%'
          transform: 'translate(-50%, -50%)'
          position: 'absolute'
          overflow: 'visible'
      },
        div { style: width: 300, background: 'white' },
          div { style: backgroundColor: 'Salmon', padding: 12, fontWeight: 'bold' }, 'Warning'
          div { style: padding: 12 },
            div {}, @props.message
            div { style: marginTop: 12, textAlign: 'right' },
              button {
                onClick: @props.onAction
                style:
                  marginLeft: 6
                  height: 22
                  width: 60
              }, 'Delete'
              button {
                onClick: @props.onCancel
                style:
                  marginLeft: 6
                  height: 22
                  width: 60
              }, 'Cancel'

module.exports = Alert
