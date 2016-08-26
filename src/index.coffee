{EventEmitter}  = require 'events'
debug           = require('debug')('meshblu-connector-hue:index')
HueManager      = require './hue-manager'
_               = require 'lodash'

class Connector extends EventEmitter
  constructor: ->
    @hue = new HueManager

  isOnline: (callback) =>
    callback null, running: true

  close: (callback) =>
    debug 'on close'
    @hue.close callback

  onConfig: (device={}, callback=->) =>
    { options, apikey, desiredState } = device
    debug 'on config', @options
    @hue.close (error) =>
      return callback error if error?
      @hue.setup {@options, apikey, @desiredState}, (error) =>
        return callback error if error?
        @connected = true
        @hue.on 'change:username', ({apikey}) =>
          @emit 'update', {apikey}
        callback()

  start: (device, callback) =>
    debug 'started'
    @onConfig device, callback

module.exports = Connector
