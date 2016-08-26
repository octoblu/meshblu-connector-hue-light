Connector = require '../'

describe 'Connector', ->
  beforeEach (done) ->
    @sut = new Connector
    {@hue} = @sut
    @hue.createClient = sinon.stub().yields null
    @sut.start {}, done

  afterEach (done) ->
    @sut.close done

  it 'should call createClient', ->
    expect(@hue.createClient).to.have.been.called

  describe 'on change:username', ->
    beforeEach ->
      @sut.emit = sinon.stub()
      apikey =
        some: 'thing'

      @hue.emit 'change:username', {apikey}

    it 'should emit update', ->
      apikey =
        some: 'thing'
      expect(@sut.emit).to.have.been.calledWith 'update', {apikey}

  xdescribe '->changeGroup', ->
    beforeEach (done) ->
      @hue.changeGroup = sinon.stub().yields null
      @sut.changeGroup groupNumber: 1, done

    it 'should call @hue.changeGroup', ->
      expect(@hue.changeGroup).to.have.been.calledWith groupNumber: 1

  xdescribe '->changeLight', ->
    beforeEach (done) ->
      @hue.changeLight = sinon.stub().yields null
      @sut.changeLight lightNumber: 1, done

    it 'should call @hue.changeLight', ->
      expect(@hue.changeLight).to.have.been.calledWith lightNumber: 1

  describe '->isOnline', ->
    it 'should yield running true', (done) ->
      @sut.isOnline (error, response) =>
        return done error if error?
        expect(response.running).to.be.true
        done()

  describe '->onConfig', ->
    describe 'when called with a config', ->
      it 'should not throw an error', ->
        expect(=> @sut.onConfig { type: 'hello' }).to.not.throw(Error)
