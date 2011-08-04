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
}, "core/controls/button": function(exports, require, module) {(function() {
  var Button, core;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  }, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  core = require('core');
  /*
  A clickable button.
  */
  module.exports = Button = (function() {
    __extends(Button, core.mvc.View);
    function Button() {
      Button.__super__.constructor.apply(this, arguments);
      this.addProps({
        pressed: false,
        canToggle: false,
        label: ''
      });
      this.pressed.onChanged(__bind(function(e) {
        if (this.canToggle() && this.pressed()) {
          return this.trigger('selected', {
            source: this
          });
        }
      }, this));
    }
    /*
      Indicates to the button that it has been clicked.
      This causes the 'click' event to fire and state values to be updated.
      @param options
              - silent : Flag indicating whether the click event should be suppressed (default false).
      */
    Button.prototype.click = function(options) {
      var fireEvent, preArgs;
      preArgs = {
        source: this,
        cancel: false
      };
      if (!this.enabled()) {
        return;
      }
      fireEvent = !((options != null ? options.silent : void 0) === true);
      if (fireEvent) {
        this.trigger('pre:click', preArgs);
        if (preArgs.cancel === true) {
          return;
        }
      }
      if (this.canToggle()) {
        this.pressed(!this.pressed());
      }
      if (fireEvent) {
        return this.trigger('click', {
          source: this
        });
      }
    };
    /*
      Wires up the specified handler to the button's [click] event.
      @param handler : Function to invoke when the button is clicked.
      */
    Button.prototype.onClick = function(handler) {
      if (handler != null) {
        return this.bind('click', handler);
      }
    };
    /*
      Wires up the specified handler to the button's [selected] event.
      The is selected when:
        1. It can toggle, and
        2. It is pressed (down)
      @param handler : Function to invoke when the button is selected.
      */
    Button.prototype.onSelected = function(handler) {
      if (handler != null) {
        return this.bind('selected', handler);
      }
    };
    return Button;
  })();
}).call(this);
}, "core/controls/index": function(exports, require, module) {(function() {
  module.exports = {
    Button: require('./button')
  };
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
  var Base, Model, basePrototype;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  }, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  Base = require('../base');
  basePrototype = new Base();
  /*
  Base class for models.
  */
  Model = (function() {
    __extends(Model, Backbone.Model);
    function Model(params) {
      var self;
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
      __bind(function() {
        var init;
        init = function(method) {
          _.extend(method, Backbone.Events);
          return method.onComplete = function(handler) {
            return method.bind('complete', handler);
          };
        };
        init(this.fetch);
        init(this.save);
        return init(this.destroy);
      }, this)();
    }
    /*
      Fetches the model's state from the server.
      @param options
              - error(model, response)   : (optional) Function to invoke if an error occurs.
              - success(model, response) : (optional) Function to invoke upon success.
      # See backbone.js documentation for more details.
      */
    Model.prototype.fetch = function(options) {
      return this._execServerMethod(this, 'fetch', options);
    };
    Model.prototype.save = function(options) {
      return this._execServerMethod(this, 'save', options);
    };
    Model.prototype.destroy = function(options) {
      return this._execServerMethod(this, 'destroy', options);
    };
    Model.prototype._execServerMethod = function(model, methodName, options) {
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
        model[methodName].trigger('complete', args);
        return typeof callback === "function" ? callback(args) : void 0;
      };
      return Backbone.Model.prototype[methodName].call(model, {
        success: function(m, response) {
          return onComplete(response, true, false, options.success);
        },
        error: function(m, response) {
          return onComplete(response, false, true, options.error);
        }
      });
    };
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
  var Base, View, syncVisibility;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  }, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  Base = require('../base');
  syncVisibility = function(view, visible) {
    var display;
    display = visible ? '' : 'none';
    return view.el.css('display', display);
  };
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
      this.addProps({
        enabled: true,
        visible: true
      });
      view = new Backbone.View({
        tagName: params.tagName,
        className: params.className
      });
      this._ = {
        view: view,
        atts: params
      };
      this.el = $(view.el);
      this.visible.onChanged(__bind(function(e) {
        return syncVisibility(this, e.newValue);
      }, this));
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
  var Property, fireEvent;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  fireEvent = __bind(function(eventName, prop, args) {
    var fire;
    fire = __bind(function(obj) {
      return obj.trigger(eventName, args);
    }, this);
    fire(prop);
    fire(prop.fn);
    return args;
  }, this);
  /*
  A function which is used as a property.
  Create an instance of this class and assign the 'fn' to a property on an object. 
  Usage:
  - Read:  the 'fn' function is invoked with no parameter.
  - Write: the 'fn' function is invoekd with a value parameter.
  */
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
      this.fireChanged = __bind(this.fireChanged, this);
      this.fireChanging = __bind(this.fireChanging, this);
      this.write = __bind(this.write, this);
      this.read = __bind(this.read, this);
      this.fn = __bind(this.fn, this);
      fn = this.fn;
      fn._parent = this;
      this.name = options.name;
      this._ = {
        store: options.store,
        "default": (_ref = options["default"]) != null ? _ref : options["default"] = null
      };
      _.extend(this, Backbone.Events);
      _.extend(fn, Backbone.Events);
      fn.onChanging = function(handler) {
        return fn.bind('changing', handler);
      };
      fn.onChanged = function(handler) {
        return fn.bind('changed', handler);
      };
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
      var args, oldValue, store;
      if (value === void 0) {
        return;
      }
      oldValue = this.read();
      if (value === oldValue) {
        return;
      }
      args = this.fireChanging(oldValue, value);
      if (args.cancel === true) {
        return;
      }
      store = this._.store;
      if (_.isFunction(store)) {
        store(this.name, value);
      } else {
        store[this.name] = value;
      }
      return this.fireChanged(oldValue, value);
    };
    /*
      Fires the 'changing' event (from the [Property] instance, and the [fn] method)
      allowing listeners to cancel the change.
      @param oldValue : The value before the property is changing from.
      @param newValue : The new value the property is changing to.
      @returns the event args.
      */
    Property.prototype.fireChanging = function(oldValue, newValue) {
      var args;
      args = {
        oldValue: oldValue,
        newValue: newValue,
        cancel: false
      };
      fireEvent('changing', this, args);
      return args;
    };
    /*
      Fires the 'changed' event (from the [Property] instance, and the [fn] method).
      @param oldValue : The value before the property is changing from.
      @param newValue : The new value the property is changing to.
      @returns the event args.
      */
    Property.prototype.fireChanged = function(oldValue, newValue) {
      return fireEvent('changed', this, {
        oldValue: oldValue,
        newValue: newValue
      });
    };
    return Property;
  })();
}).call(this);
}});
