_              = require 'lodash'
HueUtil        = require 'hue-util'
{EventEmitter} = require 'events'
tinycolor      = require 'tinycolor2'
debug          = require('debug')('meshblu-connector-hue:hue-manager')
_              = require 'lodash'

class HueManager extends EventEmitter
  connect: ({ @options, @apikey, @desiredState }, callback) =>
    @_emit = _.throttle @emit, 500, {leading: true, trailing: false}
    @apikey ?= {}
    @options ?= {}
    {apiUsername, ipAddress, @lightNumber} = @options
    {username} = @apikey
    apiUsername ?= 'newdeveloper'
    @apikey.devicetype = apiUsername
    @hue = new HueUtil apiUsername, ipAddress, username, @_onUsernameChange
    @stateInterval = setInterval @_updateState
    @changeLight @desiredState, callback

  close: (callback) =>
    clearInterval @stateTimeout
    delete @stateTimeout
    callback()

  _onUsernameChange: (username) =>
    return if username == @apikey.username
    @apikey.username = username
    @_emit 'change:username', {@apikey}

  _updateState: =>
    @hue.getLights

  # getLights: (callback) =>
  #   @hue.getLights (err, lights) =>
  #     mappedLights = {}
  #     _.forEach lights, (light, lightNumber) =>
  #       { bri, sat, hue, alert, effect } = light.state
  #
  #       bri = (bri / 254) * 100
  #       hue = (hue / 254) * 100
  #       sat = (sat / 254) * 100
  #
  #       color = "hsl(" + hue + "%," + sat + "%," + bri + "%)"
  #
  #       mappedLights[lightNumber] = {
  #         lightNumber: lightNumber,
  #         color: color,
  #         alert: alert,
  #         effect: effect,
  #         on: light.state.on
  #       }
  #     callback mappedLights
  #
  changeLight: (data, callback) =>
    return callback() if _.isEmpty data
    {
      color
      transitionTime
      alert
      effect
    } = data

    @hue.changeLights { @lightNumber, color, transitionTime, alert, effect, on: data.on }, callback

module.exports = HueManager
