/*
  Copyright 2011 Phil Cockfield. All rights reserved.
  The MIT License (MIT)
  https://github.com/philcockfield/open.core
*/

(function(/*! Stitch !*/) {
  if (!this.require) {
    var modules = {}, cache = {}, require = function(name, root) {
      var module = cache[name], path = expand(root, name), fn;
      if (module) {
        return module;
      } else if (fn = modules[path] || modules[path = expand(path, './index')]) {
        module = {id: name, exports: {}};
        try {
          cache[name] = module.exports;
          fn(module.exports, function(name) {
            return require(name, dirname(path));
          }, module);
          return cache[name] = module.exports;
        } catch (err) {
          delete cache[name];
          throw err;
        }
      } else {
        throw 'module \'' + name + '\' not found';
      }
    }, expand = function(root, name) {
      var results = [], parts, part;
      if (/^\.\.?(\/|$)/.test(name)) {
        parts = [root, name].join('/').split('/');
      } else {
        parts = name.split('/');
      }
      for (var i = 0, length = parts.length; i < length; i++) {
        part = parts[i];
        if (part == '..') {
          results.pop();
        } else if (part != '.' && part != '') {
          results.push(part);
        }
      }
      return results.join('/');
    }, dirname = function(path) {
      return path.split('/').slice(0, -1).join('/');
    };
    this.require = function(name) {
      return require(name, '');
    }
    this.require.define = function(bundle) {
      for (var key in bundle)
        modules[key] = bundle[key];
    };
  }
  return this.require.define;
}).call(this)({"core/base": function(exports, require, module) {(function() {
  var Base, Property;
  Property = require('./util/property');
  /*
  Common base class.
  This class can either be extended using standard CoffeeScript syntax (class Foo extends Base)
  or manually via underscore (_.extend source, new Base())
  */
  module.exports = Base = (function() {
    function Base() {}
    /*
      Adds one or more [Property] functions to the object.
      @param props :    Object literal describing the properties to add
                        The object takes the form [name: default-value].
                        {
                          name: 'default value'
                        }
      */
    Base.prototype.addProps = function(props) {
      var add, name, self, store, _results;
      if (props == null) {
        return;
      }
      self = this;
      store = this.propertyStore();
      add = function(name) {
        var defaultValue, prop;
        defaultValue = props[name];
        prop = new Property({
          name: name,
          "default": defaultValue,
          store: store
        });
        return self[name] = prop.fn;
      };
      _results = [];
      for (name in props) {
        if (this.hasOwnProperty(name)) {
          throw "Add property fail. [" + name + "] exists";
        }
        _results.push(add(name));
      }
      return _results;
    };
    /*
      Retrieves the property store.
      This should be either an object or a property-function. 
      Override this to provide a custom property store.
      */
    Base.prototype.propertyStore = function() {
      var internal, _ref, _ref2;
      internal = (_ref = this._) != null ? _ref : this._ = {};
      return (_ref2 = internal.basePropertyStore) != null ? _ref2 : internal.basePropertyStore = {};
    };
    return Base;
  })();
}).call(this);
}, "core/index": function(exports, require, module) {(function() {
  module.exports = {
    title: 'Open.Core (Client)',
    Base: require('./base'),
    mvc: require('./mvc/index'),
    util: require('./util')
  };
}).call(this);
}, "core/mvc/index": function(exports, require, module) {(function() {
  module.exports = {
    Model: require('./model'),
    View: require('./view'),
    Template: require('./template')
  };
}).call(this);
}, "core/mvc/model": function(exports, require, module) {(function() {
  var Base, Model, basePrototype, excludeMethod, excludeMethods, serverMethod;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  }, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  Base = require('../base');
  excludeMethods = ['initialize', 'idAttribute'];
  excludeMethod = function(name) {
    if (name.substring(0, 1) === '_') {
      return true;
    }
    if (_.any(excludeMethods, function(m) {
      return m === name;
    })) {
      return true;
    }
    return false;
  };
  /*
  Provides standardized response behavior for all of the server
  interaction methods. 
  - Fetch
  - Save
  - Destroy
  */
  serverMethod = function(model, wrappedMethod) {
    var fnProxy;
    fnProxy = function(options) {
      var onComplete;
      if (options == null) {
        options = {};
      }
      onComplete = function(response, success, error, callback) {
        var args;
        args = {
          model: model,
          response: response,
          success: success,
          error: error
        };
        fnProxy.trigger('complete', args);
        return typeof callback === "function" ? callback(args) : void 0;
      };
      return fnProxy._wrapped({
        success: function(m, response) {
          return onComplete(response, true, false, options.success);
        },
        error: function(m, response) {
          return onComplete(response, false, true, options.error);
        }
      });
    };
    _.extend(fnProxy, Backbone.Events);
    fnProxy.onComplete = function(handler) {
      return fnProxy.bind('complete', handler);
    };
    fnProxy._wrapped = wrappedMethod;
    return fnProxy;
  };
  basePrototype = new Base();
  /*
  Base class for models.
  */
  Model = (function() {
    __extends(Model, Backbone.Model);
    function Model(params) {
      var key, model, self;
      if (params == null) {
        params = {};
      }
      Model.__super__.constructor.apply(this, arguments);
      self = this;
      _.extend(this, basePrototype);
      this.propertyStore = __bind(function() {
        var fn;
        return fn = __bind(function(name, value) {
          var param;
          if (value !== void 0) {
            param = {};
            param[name] = value;
            self.set(param);
          }
          return self.get(name);
        }, this);
      }, this);
      model = new Backbone.Model();
      this._ = {
        model: model
      };
      this.fetch = serverMethod(this, model.fetch);
      this.save = serverMethod(this, model.save);
      this.destroy = serverMethod(this, model.destroy);
      for (key in model) {
        if (this[key] !== void 0 || excludeMethod(key)) {
          continue;
        }
        this[key] = model[key];
      }
      this.atts = this.attributes;
    }
    /*
      Fetches the model's state from the server.
      @param options
              - error(model, response)   : (optional) Function to invoke if an error occurs.
              - success(model, response) : (optional) Function to invoke upon success.
      # See backbone.js documentation for more details.
      */
    Model.prototype.fetch = void 0;
    Model.prototype.save = void 0;
    Model.prototype.destroy = void 0;
    return Model;
  })();
  module.exports = Model;
}).call(this);
}, "core/mvc/template": function(exports, require, module) {(function() {
  /*
  Helper for simple client-side templates using the Underscore template engine.
  */  var Template;
  Template = (function() {
    function Template() {
      var exclude, key, value;
      exclude = ['constructor'];
      for (key in this) {
        if (!(_(exclude).any(function(item) {
          return item === key;
        }))) {
          value = this[key];
          if (_(value).isString()) {
            this[key] = new _.template(value);
          }
        }
      }
    }
    return Template;
  })();
  module.exports = Template;
}).call(this);
}, "core/mvc/view": function(exports, require, module) {(function() {
  var Base, View;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  };
  Base = require('../base');
  /*
  Base class for visual controls.
  */
  module.exports = View = (function() {
    __extends(View, Base);
    function View(params) {
      var view;
      if (params == null) {
        params = {};
      }
      View.__super__.constructor.apply(this, arguments);
      _.extend(this, Backbone.Events);
      view = new Backbone.View({
        tagName: params.tagName,
        className: params.className
      });
      this._ = {
        view: view,
        atts: params
      };
      this.el = $(view.el);
      this.$ = view.$;
    }
    /*
      Renders the given HTML within the view.
      */
    View.prototype.html = function(html) {
      var el;
      el = this.el;
      if (html != null) {
        el.html(html);
      }
      return el.html();
    };
    /*
      Gets or sets whether the view is visible.
      */
    View.prototype.visible = function(isVisible) {
      if (isVisible != null) {
        this.el.css('display', isVisible ? '' : 'none');
      }
      return this.el.css('display') !== 'none';
    };
    return View;
  })();
}).call(this);
}, "core/util/index": function(exports, require, module) {(function() {
  module.exports = {
    Property: require('./property'),
    /*
      Converts a value to boolean.
      @param value: To convert.
      @returns True for:
                - true
                - 1
                - 'true' (any case permutation)
                - 'yes'
                - 'on'
               False for:
                - false
                - 0
                - 'false' (any case permutation)
                - 'no'
                - 'off'
               Null for:
                - object
      */
    toBool: function(value) {
      if (_.isBoolean(value)) {
        return value;
      }
      if (value == null) {
        return false;
      }
      if (_.isString(value)) {
        value = _.trim(value).toLowerCase();
        if (value === 'true' || value === 'on' || value === 'yes') {
          return true;
        }
        if (value === 'false' || value === 'off' || value === 'no') {
          return false;
        }
        return null;
      }
      if (_.isNumber(value)) {
        if (value === 1) {
          return true;
        }
        if (value === 0) {
          return false;
        }
        return null;
      }
      return null;
    }
  };
}).call(this);
}, "core/util/property": function(exports, require, module) {(function() {
  /*
  A function which is used as a property.
  Create an instance of this class and assign the 'fn' to a property on an object. 
  Usage:
  - Read:  the 'fn' function is invoked with no parameter.
  - Write: the 'fn' function is invoekd with a value parameter.
  */  var Property;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  module.exports = Property = (function() {
    /*
      Constructor.
      @param options
                - name:    (required) The name of the property.
                - store:   (required) Either the object to store values in (using the 'name' as key)
                                      of a function used to read/write values to another store.
                - default: (optional) The default value to use.
      */    function Property(options) {
      var fn, _ref;
      if (options == null) {
        options = {};
      }
      this.fireChange = __bind(this.fireChange, this);
      this.write = __bind(this.write, this);
      this.read = __bind(this.read, this);
      this.fn = __bind(this.fn, this);
      fn = this.fn;
      this.name = options.name;
      this._ = {
        store: options.store,
        "default": (_ref = options["default"]) != null ? _ref : options["default"] = null
      };
      _.extend(this, Backbone.Events);
      _.extend(fn, Backbone.Events);
      fn._parent = this;
    }
    /*
      The primary read/write function of the property.
      Expose this from your objects as a property-func.
      @param value (optional) the value to assign.  
                   Do not specify (undefined) for read operations.
      */
    Property.prototype.fn = function(value) {
      if (value !== void 0) {
        this.write(value);
      }
      return this.read();
    };
    /*
      Reads the property value.
      */
    Property.prototype.read = function() {
      var store, value;
      store = this._.store;
      if (_.isFunction(store)) {
        value = store(this.name);
      } else {
        value = store[this.name];
      }
      if (value === void 0) {
        value = this._["default"];
      }
      return value;
    };
    /*
      Writes the given value to the property.
      */
    Property.prototype.write = function(value) {
      var oldValue, store;
      if (value === void 0) {
        return;
      }
      oldValue = this.read();
      if (value === oldValue) {
        return;
      }
      store = this._.store;
      if (_.isFunction(store)) {
        store(this.name, value);
      } else {
        store[this.name] = value;
      }
      return this.fireChange(oldValue, value);
    };
    /*
      Fires the change event (from the [Property] instance, and the [fn] method).
      @param oldValue : The value before the property is changing from.
      @param newValue : The new value the property is changing to.
      */
    Property.prototype.fireChange = function(oldValue, newValue) {
      var fire;
      fire = __bind(function(obj) {
        return obj.trigger('change', {
          oldValue: oldValue,
          newValue: newValue
        });
      }, this);
      fire(this);
      return fire(this.fn);
    };
    return Property;
  })();
}).call(this);
}});
