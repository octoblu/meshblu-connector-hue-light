{afterEach, beforeEach, context, describe, it} = global
{expect}   = require 'chai'
sinon      = require 'sinon'
HueManager = require '../src/hue-manager'

describe 'HueManager', ->
  beforeEach ->
    @sut = new HueManager
    @sut._updateState = sinon.stub().yields null
    @sut.verify = sinon.stub().yields null

  afterEach (done) ->
    @sut.close done

  describe '->connect', ->
    beforeEach (done) ->
      @sut.connect {}, done

    it 'should create a hue connection', ->
      expect(@sut.hue).to.exist

    it 'should update apikey', ->
      apikey =
        devicetype: 'octoblu-hue-light'
      expect(@sut.apikey).to.deep.equal apikey

  context 'with an active client', ->
    beforeEach (done) ->
      options =
        lightNumber: 4
      @sut.connect {options}, (error) =>
        {@hue} = @sut
        done error

    describe '->changeLight', ->
      beforeEach (done) ->
        @hue.changeLights = sinon.stub().yields null
        data =
          on: true
          alert: 'none'
          color: 'white'
          effect: 'none'
          transitionTime: 0
        @sut.changeLight data, done

      it 'should call changeLights', ->
        options =
           lightNumber: 4
           on: true
           alert: 'none'
           color: 'white'
           effect: 'none'
           transitionTime: 0
        expect(@hue.changeLights).to.have.been.calledWith options

  context 'on state change', ->
    beforeEach (done) ->
      options =
        lightNumber: 4

      @sut.connect {options}, (error) =>
        {@hue} = @sut
        done error

    describe '->changeLight', ->
      beforeEach (done) ->
        @hue.changeLights = sinon.stub().yields null
        data =
          on: true
          alert: 'none'
          color: 'white'
          effect: 'none'
          transitionTime: 0
        @sut.changeLight data, done

      it 'should call changeLights', ->
        options =
           lightNumber: 4
           on: true
           alert: 'none'
           color: 'white'
           effect: 'none'
           transitionTime: 0
        expect(@hue.changeLights).to.have.been.calledWith options
