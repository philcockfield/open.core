describe 'util/property', ->
  Property = null
  beforeEach ->
    Property = core.util.Property

  it 'exists', ->
    expect(Property).toBeDefined()
  
  it 'exposes name', ->
    prop = new Property( name:'foo', store: {} )
    expect(prop.name).toEqual 'foo'
  
  it 'exposes _parent from [fn] method', ->
    prop = new Property( name:'foo', store: {} )
    expect(prop.fn._parent).toEqual prop
    
  
  describe 'reading values', ->
    it 'reads null value', ->
      prop = new Property( name:'foo', store: {} )
      expect(prop.fn()).toEqual null

    it 'reads default', ->
      prop = new Property( name:'foo', store: {}, default:123 )
      expect(prop.fn()).toEqual 123
    
    it 'defers to the [read] method', ->
      prop = new Property( name:'foo', store: {} )
      spyOn prop, 'read'
      prop.fn()
      expect(prop.read).toHaveBeenCalled()

    it 'does not defer to the [write] method', ->
      prop = new Property( name:'foo', store: {} )
      spyOn prop, 'write'
      prop.fn()
      expect(prop.write).not.toHaveBeenCalled()

    
  describe 'writing values', ->
    it 'writes a value', ->
      prop = new Property( name:'foo', store: {}, default:123 )
      prop.fn('abc')
      expect(prop.fn()).toEqual 'abc'

    it 'writes null', ->
      prop = new Property( name:'foo', store: {}, default:123 )
      prop.fn(null)
      expect(prop.fn()).toEqual null

    it 'defers to the [write] method', ->
      prop = new Property( name:'foo', store: {} )
      spyOn prop, 'write'
      prop.fn(123)
      expect(prop.write).toHaveBeenCalled()
      
  
  describe 'function store', ->
    fnStore = null
    prop = null
    readValue = undefined
    writeName = null
    writeTotal = 0
    
    beforeEach ->
      readValue = undefined
      writeTotal = 0
      writeName = null
      fnStore = (name, value) -> 
             if value != undefined
                 readValue = value
                 writeTotal += 1
                 writeName = name
             readValue
             
      prop = new Property( name:'foo', store:fnStore, default:123 )
    
    describe 'read', ->
      it 'reads from function-store', ->
        readValue = 'hello'
        expect(prop.fn()).toEqual 'hello'

      it 'reads default value from function-store', ->
        expect(prop.fn()).toEqual 123

    describe 'write', ->
      it 'writes a value', ->
        prop.fn('abc')
        expect(prop.fn()).toEqual 'abc'

      it 'writes null', ->
        prop.fn(null)
        expect(prop.fn()).toEqual null
      
      it 'passes the name to the function-store', ->
        prop.fn('abc')
        expect(writeName).toEqual 'foo'
      
      it 'calls the function-store once', ->
        prop.fn('abc')
        prop.fn('abc')
        prop.fn('abc')
        expect(writeTotal).toEqual 1
        
    
  describe 'event: changing', ->
    prop = null
    args = null
    count = 0
    cancel = false
    beforeEach ->
      count = 0
      cancel = false
      args = null
      prop = new Property( name:'foo', store: {}, default:123 )
      prop.bind 'changing', (e) -> 
            count += 1
            args = e
            args.cancel = cancel
    
    describe 'fireChanging method', ->
      it 'fires [changing] event from class', ->
        prop.fireChanging()
        expect(count).toEqual 1
      
      it 'fires [changing] event from [fn] method', ->
        prop.fireChanging()
        expect(count).toEqual 1
      
      it 'passes values as args in event', ->
        prop.fireChanging(1, 2)
        expect(args.oldValue).toEqual 1
        expect(args.newValue).toEqual 2
        expect(args.cancel).toEqual false

    describe '[changing] event when writing', ->
      it 'fires [changing] event when value is different', ->
        prop.fn('abc')
        expect(count).toEqual 1

      it 'does not fire [changing] event when value is the same (as default)', ->
        prop.fn(123)
        expect(count).toEqual 0

      it 'does not fire [changing] event when value is the same (multiple changes with same value)', ->
        prop.fn('abc')
        prop.fn('abc')
        prop.fn('abc')
        expect(count).toEqual 1

      it 'passes the old and new values in event args', ->
        prop.fn('abc')
        expect(args.oldValue).toEqual 123
        expect(args.newValue).toEqual 'abc'

      it 'does not change property value when cancelled', ->
        cancel = true
        prop.fn(987)
        expect(prop.fn()).toEqual 123

    describe 'Handler helper: onChanging', ->
      it 'binds to [changing] event', ->
        prop.fn.onChanging (e) -> args = e
        prop.fn 'abc'
        expect(prop.fn()).toEqual 'abc'
        expect(args.oldValue).toEqual 123
        expect(args.newValue).toEqual 'abc'

      it 'cancels bound event', ->
        prop.fn.onChanging (e) -> args.cancel = yes
        prop.fn 'abc'
        expect(prop.fn()).toEqual 123
  
    
  describe 'event: changed', ->
    prop = null
    args = null
    count = 0
    beforeEach ->
      count = 0
      args = null
      prop = new Property( name:'foo', store: {}, default:123 )
      prop.bind 'changed', (e) -> 
            count += 1
            args = e

    describe 'fireChanged method', ->
      it 'fires change event from class', ->
        prop.fireChanged()
        expect(count).toEqual 1
      
      it 'fires change event from [fn] method', ->
        prop.fireChanged()
        expect(count).toEqual 1
      
      it 'passes values as args in event', ->
        prop.fireChanged(1, 2)
        expect(args.oldValue).toEqual 1
        expect(args.newValue).toEqual 2
    
    describe '[changed] event when writing', ->
      it 'fires [changed] event when value is different', ->
        prop.fn('abc')
        expect(count).toEqual 1

      it 'does not fire [changed] event when value is the same (as default)', ->
        prop.fn(123)
        expect(count).toEqual 0

      it 'does not fire [changed] event when value is the same (multiple changes with same value)', ->
        prop.fn('abc')
        prop.fn('abc')
        prop.fn('abc')
        expect(count).toEqual 1

      it 'passes the old and new values in event args', ->
        prop.fn('abc')
        expect(args.oldValue).toEqual 123
        expect(args.newValue).toEqual 'abc'
        
    describe 'Handler helper: onChanged', ->
      it 'binds to [changed] event', ->
        prop.fn.onChanged (e) -> args = e
        prop.fn 'abc'
        expect(prop.fn()).toEqual 'abc'
        expect(args.oldValue).toEqual 123
        expect(args.newValue).toEqual 'abc'

        
      
    describe 'async', ->
      prop = null
      beforeEach ->
          prop = new Property( name:'foo', store: {}, default:123 )
    
      it 'reads from an async callback', ->
        value = null
        read = -> value = prop.fn()
        setTimeout read, 5
        waitsFor -> value != null
        runs -> 
          expect(value).toEqual 123

      it 'writes from an async callback', ->
        written = false
        write = -> 
                prop.fn('hello')
                written = true
        setTimeout write, 5
        waitsFor -> written == true
        runs -> 
          expect(prop.fn()).toEqual 'hello'

      it 'binds to [changing] event and cancels change from an async callback', ->
        fired = false
        args = null
        prop.fn.onChanging (e) -> 
                    args = e
                    fired = true
                    e.cancel = true
        write = -> prop.fn('hello')
        setTimeout write, 5
        waitsFor -> fired == true
        runs -> 
          expect(args.newValue).toEqual 'hello'
          expect(prop.fn()).toEqual 123

      it 'binds to [changed] event from an async callback', ->
        fired = false
        prop.fn.onChanged (e) -> 
                    fired = true
        write = -> prop.fn('hello')
        setTimeout write, 5
        waitsFor -> fired == true
        runs -> 
          expect(prop.fn()).toEqual 'hello'
        
        
        
        
      
      
    
    
    
    