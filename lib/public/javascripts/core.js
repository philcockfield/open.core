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
}).call(this)({"open.client/controls/button": function(exports, require, module) {(function() {
  var Button, core;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; }, __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  };
  core = require('open.client/core');
  /*
  A click-able button.
  Events:
    - selected
    - pre:click
    - click
    - stateChanged
  */
  module.exports = Button = (function() {
    __extends(Button, core.mvc.View);
    /*
      Constructor.
      @param params : used to override default property values.
      */
    function Button(params) {
      var self, _ref, _ref2, _ref3;
      if (params == null) {
        params = {};
      }
      this._stateChanged = __bind(this._stateChanged, this);
      this.handleStateChanged = __bind(this.handleStateChanged, this);
      this.toggle = __bind(this.toggle, this);
      this.onSelected = __bind(this.onSelected, this);
      this.onClick = __bind(this.onClick, this);
      this.click = __bind(this.click, this);
      self = this;
      Button.__super__.constructor.call(this, params);
      this.addProps({
        label: (_ref = params.label) != null ? _ref : params.label = '',
        canToggle: (_ref2 = params.canToggle) != null ? _ref2 : params.canToggle = false,
        selected: (_ref3 = params.selected) != null ? _ref3 : params.selected = false,
        over: false,
        down: false
      });
      this.selected.onChanged(__bind(function() {
        var isSelected;
        isSelected = self.selected();
        self._stateChanged('selected');
        self.handleSelectedChanged({
          selected: isSelected
        });
        if (self.canToggle() && isSelected) {
          return self.trigger('selected', {
            source: self
          });
        }
      }, this));
      (function() {
        var el, stateChanged;
        el = self.el;
        stateChanged = self._stateChanged;
        el.mouseenter(__bind(function(e) {
          self.over(true);
          return stateChanged('mouseenter');
        }, this));
        el.mouseleave(__bind(function(e) {
          self.over(false);
          self.down(false);
          return stateChanged('mouseleave');
        }, this));
        el.mousedown(__bind(function(e) {
          self.down(true);
          return stateChanged('mousedown');
        }, this));
        return el.mouseup(__bind(function(e) {
          self.down(false);
          return self.click();
        }, this));
      })();
    }
    /*
      Indicates to the button that it has been clicked.
      This causes the 'click' event to fire and state values to be updated.
      @param options
              - silent : Flag indicating whether the click event should be suppressed (default false).
      @returns true if the click operation completed successfully, or false if it was cancelled.
      */
    Button.prototype.click = function(options) {
      var fireEvent, preArgs;
      if (options == null) {
        options = {};
      }
      preArgs = {
        source: this,
        cancel: false
      };
      if (!this.enabled()) {
        return;
      }
      fireEvent = !(options.silent === true);
      if (fireEvent) {
        this.trigger('pre:click', preArgs);
        if (preArgs.cancel === true) {
          this._stateChanged('click:cancelled');
          return false;
        }
      }
      this.toggle();
      if (fireEvent) {
        this.trigger('click', {
          source: this
        });
      }
      this._stateChanged('click');
      return true;
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
        2. It is selected (down)
      @param handler : Function to invoke when the button is selected.
      */
    Button.prototype.onSelected = function(handler) {
      if (handler != null) {
        return this.bind('selected', handler);
      }
    };
    /*
      Toggles the selected state (if the button can toggle).
      @returns true if the button was toggled, or false if the button cannot toggle.
      */
    Button.prototype.toggle = function() {
      if (!this.canToggle()) {
        return false;
      }
      this.selected(!this.selected());
      return true;
    };
    /*
      Invoked when the state of the button has changed (ie. via a mouse event)
      Override this to update visual state.
      See corresponding event: 'stateChanged'
      @param args: 
              - state:    String indicating what state caused the change.
      */
    Button.prototype.handleStateChanged = function(args) {};
    /*
      Invoked when the selection has changed.
      Override this to update visual state.
      See corresponding event: 'selected'
      @param args: 
              - selected:  Flag indicating if the button is currenlty selected.
      */
    Button.prototype.handleSelectedChanged = function(args) {};
    /*
      PRIVATE MEMBERS
      */
    Button.prototype._stateChanged = function(state) {
      var args;
      args = {
        source: this,
        state: state
      };
      this.trigger('stateChanged', args);
      return this.handleStateChanged(args);
    };
    return Button;
  })();
}).call(this);
}, "open.client/controls/button_set": function(exports, require, module) {(function() {
  var ButtonSet, core;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  }, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  core = require('open.client/core');
  /*
  Manages a set of toggle buttons providing single-selection 
  behavior (for example, a tab set).
  
  Events:
    - add
    - remove
    - clear
    - selectionChanged
  
  */
  module.exports = ButtonSet = (function() {
    __extends(ButtonSet, core.Base);
    function ButtonSet() {
      ButtonSet.__super__.constructor.apply(this, arguments);
      _.extend(this, Backbone.Events);
      this.length = 0;
      this.buttons = new core.mvc.Collection();
      this.contains = this.buttons.include;
    }
    /*
      Gets the collection of buttons being managed.
      */
    ButtonSet.prototype.buttons = void 0;
    /*
      Retrieves the collection of toggle-buttons that are currently in a selected state.
      */
    ButtonSet.prototype.selected = function() {
      return (this.buttons.select(function(btn) {
        return btn.canToggle() && btn.selected();
      }))[0];
    };
    /*
      Selects the buttons that can be toggled.
      */
    ButtonSet.prototype.togglable = function() {
      return this.buttons.select(function(btn) {
        return btn.canToggle();
      });
    };
    /*
      Adds a button to the set.
      @param button : The button to add.
      @param options
                silent: supresses the 'add' event (default false).
      @returns the added button.
      */
    ButtonSet.prototype.add = function(button, options) {
      if (options == null) {
        options = {};
      }
      if (button == null) {
        throw 'add: no button';
      }
      if (this.buttons.include(button)) {
        return button;
      }
      this.buttons.add(button, options);
      this.length = this.buttons.length;
      button.bind('pre:click', function(e) {
        if (button.selected()) {
          return e.cancel = true;
        }
      });
      button.selected.onChanged(__bind(function(e) {
        var btn, _i, _len, _ref;
        if (!button.canToggle()) {
          return;
        }
        if (e.oldValue === true) {
          return;
        }
        _ref = this.togglable();
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          btn = _ref[_i];
          if (btn !== button && btn.canToggle() && btn.selected()) {
            btn.selected(false);
          }
        }
        return this._fire('selectionChanged', {
          button: button
        });
      }, this));
      if (!options.silent) {
        this._fire('add');
        this._fireChanged();
      }
      return button;
    };
    /*
      Removes the specified button from the set.
      @param button: The button to remove.
      @param options
                silent: supresses the 'remove' event (default false).
      @returns true if the button was removed, of false if the button did not exist in the set.
      */
    ButtonSet.prototype.remove = function(button, options) {
      var _ref;
      if (options == null) {
        options = {};
      }
      if (button == null) {
        throw 'remove: no button';
      }
      if (!this.buttons.include(button)) {
        return false;
      }
            if ((_ref = options._fireChanged) != null) {
        _ref;
      } else {
        options._fireChanged = true;
      };
      this.buttons.remove(button, options);
      this.length = this.buttons.length;
      button.unbind('pre:click');
      button.selected.unbind('changed');
      if (!options.silent) {
        this._fire('remove');
        if (options._fireChanged) {
          this._fireChanged();
        }
      }
      return true;
    };
    /*
      Removes all buttons from the set.
      @param options
                silent: supresses the 'remove' event (default false).
      */
    ButtonSet.prototype.clear = function(options) {
      var btn, buttons, _i, _len, _ref;
      if (options == null) {
        options = {};
      }
            if ((_ref = options.silent) != null) {
        _ref;
      } else {
        options.silent = false;
      };
      options._fireChanged = false;
      buttons = this.buttons.select(function() {
        return true;
      });
      for (_i = 0, _len = buttons.length; _i < _len; _i++) {
        btn = buttons[_i];
        this.remove(btn, options);
      }
      if (!options.silent) {
        this._fire('clear');
        this._fireChanged();
      }
      return null;
    };
    /*
      PRIVATE Methods
      */
    ButtonSet.prototype._fire = function(event, args) {
      if (args == null) {
        args = {};
      }
      args.source = this;
      return this.trigger(event, args);
    };
    ButtonSet.prototype._fireChanged = function() {
      return this._fire('changed');
    };
    return ButtonSet;
  })();
}).call(this);
}, "open.client/controls/index": function(exports, require, module) {(function() {
  module.exports = {
    Button: require('./button'),
    ButtonSet: require('./button_set'),
    Textbox: require('./textbox')
  };
}).call(this);
}, "open.client/controls/textbox/index": function(exports, require, module) {(function() {
  var Template, Textbox, core, textSyncer;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  }, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  core = require('open.client/core');
  Template = require('./tmpl');
  textSyncer = function(textProperty, input) {
    var ignore, sync, syncInput, syncProperty;
    ignore = false;
    sync = function(fn) {
      ignore = true;
      fn();
      return ignore = false;
    };
    syncInput = function() {
      if (ignore) {
        return;
      }
      return sync(function() {
        return input.val(textProperty());
      });
    };
    syncInput();
    textProperty.onChanged(syncInput);
    syncProperty = function() {
      if (ignore) {
        return;
      }
      return sync(function() {
        return textProperty(input.val());
      });
    };
    input.keyup(syncProperty);
    return input.change(syncProperty);
  };
  /*
  A general purpose textbox.
  
  Events:
   - press:enter
   - press:escape
  
  */
  module.exports = Textbox = (function() {
    __extends(Textbox, core.mvc.View);
    Textbox.prototype.defaults = {
      text: '',
      multiline: false,
      password: false,
      watermark: ''
    };
    function Textbox(params) {
      var keyHandlers, syncWatermark;
      if (params == null) {
        params = {};
      }
      Textbox.__super__.constructor.call(this, _.extend(params, {
        tagName: 'span',
        className: 'core_textbox'
      }));
      this.render();
      syncWatermark = __bind(function() {
        return this.$('span.core_watermark').html((this.empty() ? this.watermark() : ''));
      }, this);
      this.multiline.onChanged(__bind(function() {
        return this.render();
      }, this));
      this.password.onChanged(__bind(function() {
        return this.render();
      }, this));
      this.watermark.onChanged(syncWatermark);
      this.text.onChanged(syncWatermark);
      this._.input.keyup(__bind(function(e) {
        if (e.keyCode === 13) {
          this.enterPress();
        }
        if (e.keyCode === 27) {
          return this.escapePress();
        }
      }, this));
      _.extend(this._, keyHandlers = {
        press: __bind(function(event) {
          return this.trigger('press:' + event, {
            source: self
          });
        }, this),
        onPress: __bind(function(event, callback) {
          return this.bind('press:' + event, callback);
        }, this)
      });
      syncWatermark();
    }
    Textbox.prototype.render = function() {
      var html, input, inputType, tmpl;
      inputType = this.password() ? 'password' : 'text';
      tmpl = new Template();
      html = tmpl.root({
        textbox: this,
        inputType: inputType
      });
      this.html(html);
      input = this.multiline() ? this.$('textarea') : this.$('input');
      this._.syncer = new textSyncer(this.text, input);
      this._.input = input;
      return this;
    };
    Textbox.prototype.focus = function() {
      return this._.input.focus();
    };
    Textbox.prototype.hasFocus = function() {
      return this.$('input:focus').length === 1;
    };
    /*
      Determines whether the textbox is empty.
      @param trim : Flag indicating if white space should be trimmed before 
                    evaluating whether the textbox is empty (default true).
      */
    Textbox.prototype.empty = function(trim) {
      var text;
      if (trim == null) {
        trim = true;
      }
      text = this.text();
      if (!(text != null)) {
        return true;
      }
      if (trim) {
        text = _.trim(text);
      }
      if (text === '') {
        return true;
      }
      return false;
    };
    /*
      Called when the [Enter] key is pressed.
      This can also be used to simulate the [Enter] key press event.
      */
    Textbox.prototype.enterPress = function() {
      return this._.press('enter');
    };
    /*
      Called when the [Escape] key is pressed.
      Note: This can also be used to simulate the [Escape] key press event.
      */
    Textbox.prototype.escapePress = function() {
      return this._.press('escape');
    };
    /*
      Wires an event handler to the [Enter] key-press.
      @param callback: to invoke when the [Enter] key is pressed.
      */
    Textbox.prototype.onEnter = function(callback) {
      return this._.onPress('enter', callback);
    };
    /*
      Wires an event handler to the [Escape] key-press.
      @param callback: to invoke when the [Escape] key is pressed.
      */
    Textbox.prototype.onEscape = function(callback) {
      return this._.onPress('escape', callback);
    };
    return Textbox;
  })();
}).call(this);
}, "open.client/controls/textbox/tmpl": function(exports, require, module) {(function() {
  var TextboxTmpl, core;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  };
  core = require('open.client/core');
  module.exports = TextboxTmpl = (function() {
    __extends(TextboxTmpl, core.mvc.Template);
    function TextboxTmpl() {
      TextboxTmpl.__super__.constructor.apply(this, arguments);
    }
    TextboxTmpl.prototype.root = "<span class=\"core_inner\">\n  &nbsp;\n  <span class=\"core_watermark\"></span>\n  <% if (textbox.multiline()) { %>\n    <textarea></textarea>\n  <% } else { %>\n    <input type=\"<%= inputType %>\" />\n  <% } %>\n</span>";
    return TextboxTmpl;
  })();
}).call(this);
}, "open.client/core/base": function(exports, require, module) {(function() {
  var Base, Property;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  Property = require('./util/property');
  /*
  Common base class.
  This class can either be extended using standard CoffeeScript syntax (class Foo extends Base)
  or manually via underscore (_.extend source, new Base())
  
    OPTIONAL OVERRIDES: 
    - onPropAdded(prop)  : Invoked when a property is added.
    - onChanged(args)    : Invokd when a property value changes.
                           args:
                              - property : The property that has changed
                              - oldValue : The old value changing from.
                              - newValue : The new value changing to.
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
        var defaultValue, monitorChange, prop;
        defaultValue = props[name];
        prop = new Property({
          name: name,
          "default": defaultValue,
          store: store
        });
        self[name] = prop.fn;
        if (self.onPropAdded != null) {
          self.onPropAdded(prop);
        }
        if (self.onChanged != null) {
          monitorChange = function(p) {
            return p.fn.onChanged(function(e) {
              return self.onChanged(e);
            });
          };
          return monitorChange(prop);
        }
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
    /*
      Attaches to an event on an object and refires it from this object.
      @param eventName    : The name of the event to bubble.
      @param eventSource  : The child object that will originally fire the event.
      */
    Base.prototype.bubble = function(eventName, eventSource) {
      if (!(this.bind != null)) {
        _.extend(this, Backbone.Events);
      }
      eventSource.bind(eventName, __bind(function(args) {
        if (args == null) {
          args = {};
        }
        args.source = this;
        return this.trigger(eventName, args);
      }, this));
      return this;
    };
    return Base;
  })();
}).call(this);
}, "open.client/core/index": function(exports, require, module) {(function() {
  var core, using, util;
  using = function(module) {
    return require('open.client/core/' + module);
  };
  util = using('util');
  module.exports = core = {
    title: 'Open.Core (Client)',
    Base: using('base'),
    mvc: using('mvc'),
    util: util,
    tryRequire: util.tryRequire
  };
}).call(this);
}, "open.client/core/mvc/_common": function(exports, require, module) {(function() {
  module.exports = {
    using: function(module) {
      return require('open.client/core/mvc/' + module);
    },
    /*
      Provides common callback functionality for executing sync (server) method.
      @param fnSync       : The Backbone function to execute (eg. Backbone.Model.fetch).
      @param source       : The source object that is syncing.
      @param methodName   : The name of the sync method (eg. 'fetch').
      @param options      : The options passed to the method (contains success/error callbacks).
      */
    sync: function(fnSync, source, methodName, options) {
      var fire, onComplete;
      if (options == null) {
        options = {};
      }
      fire = function(event, args) {
        return source[methodName].trigger(event, args);
      };
      onComplete = function(response, success, error, callback) {
        var args;
        args = {
          source: source,
          response: response,
          success: success,
          error: error
        };
        fire('complete', args);
        return typeof callback === "function" ? callback(args) : void 0;
      };
      fire('start', {
        source: source
      });
      return fnSync.call(source, {
        success: function(m, response) {
          return onComplete(response, true, false, options.success);
        },
        error: function(m, response) {
          return onComplete(response, false, true, options.error);
        }
      });
    }
  };
}).call(this);
}, "open.client/core/mvc/collection": function(exports, require, module) {(function() {
  var Collection, common;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  };
  common = require('open.client/core/mvc/_common');
  /*
  Base class for Collections.
  */
  module.exports = Collection = (function() {
    __extends(Collection, Backbone.Collection);
    function Collection() {
      Collection.__super__.constructor.apply(this, arguments);
      _.extend(this.fetch, Backbone.Events);
    }
    /*
      Overrides the Backbone fetch method, enabling fetch events.
      @param options
              - error(args)   : (optional) Function to invoke if an error occurs.
              - success(args) : (optional) Function to invoke upon success.
                                Result args:
                                  - collection  : The collection.
                                  - response    : The response data.
                                  - success     : {bool} Flag indicating if the operation was successful
                                  - error       : {bool} Flag indicating if the operation was in error.
      */
    Collection.prototype.fetch = function(options) {
      var fetch, fn;
      fetch = 'fetch';
      fn = Backbone.Collection.prototype[fetch];
      return common.sync(fn, this, fetch, options);
    };
    Collection.prototype.onFetched = function(callback) {
      if (callback != null) {
        return this.fetch.bind('complete', callback);
      }
    };
    return Collection;
  })();
}).call(this);
}, "open.client/core/mvc/index": function(exports, require, module) {(function() {
  var common, using;
  common = require('open.client/core/mvc/_common');
  using = common.using;
  module.exports = {
    Model: using('model'),
    View: using('view'),
    Template: using('template'),
    Collection: using('collection'),
    Module: using('module')
  };
}).call(this);
}, "open.client/core/mvc/model": function(exports, require, module) {(function() {
  var Base, Model, basePrototype, common;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  }, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  Base = require('../base');
  common = require('./_common');
  basePrototype = new Base();
  /*
  Base class for models.
  */
  module.exports = Model = (function() {
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
        return fn = __bind(function(name, value, options) {
          var param;
          if (value !== void 0) {
            param = {};
            param[name] = value;
            self.set(param, options);
          }
          return self.get(name);
        }, this);
      }, this);
      self.addProps(this.defaults);
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
      Adds one or more [Property] functions to the object.
      @param props :    Object literal describing the properties to add
                        The object takes the form [name: default-value].
                        {
                          name: 'default value'
                        }
      */
    Model.prototype.addProps = function(props) {
      return console.log('FOO', props);
    };
    /*
      Fetches the model's state from the server.
      @param options
              - error(args)   : (optional) Function to invoke if an error occurs.
              - success(args) : (optional) Function to invoke upon success.
                              result args:
                                  - model    : The model.
                                  - response : The response data.
                                  - success  : {bool} Flag indicating if the operation was successful
                                  - error    : {bool} Flag indicating if the operation was in error.
      # See backbone.js documentation for more details.
      */
    Model.prototype.fetch = function(options) {
      return this._sync(this, 'fetch', options);
    };
    Model.prototype.save = function(options) {
      return this._sync(this, 'save', options);
    };
    Model.prototype.destroy = function(options) {
      return this._sync(this, 'destroy', options);
    };
    Model.prototype._sync = function(model, methodName, options) {
      var fn;
      if (options == null) {
        options = {};
      }
      fn = Backbone.Model.prototype[methodName];
      return common.sync(fn, model, methodName, options);
    };
    return Model;
  })();
}).call(this);
}, "open.client/core/mvc/module": function(exports, require, module) {(function() {
  var Base, Module, common, using, util;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  }, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  using = function(module) {
    return require('open.client/core/' + module);
  };
  Base = using('base');
  common = using('/mvc/_common');
  util = using('util');
  module.exports = Module = (function() {
    __extends(Module, Base);
    Module.prototype.tryRequire = util.tryRequire;
    /*
      Constructor.
      @param modulePath: The path to the module.
      */
    function Module(modulePath) {
      var _require;
      Module.__super__.constructor.apply(this, arguments);
      _require = __bind(function(dir) {
        return __bind(function(name, options) {
          var _ref;
          if (name == null) {
            name = '';
          }
          if (options == null) {
            options = {};
          }
                    if ((_ref = options["throw"]) != null) {
            _ref;
          } else {
            options["throw"] = true;
          };
          return this.tryRequire("" + modulePath + "/" + dir + "/" + name, options);
        }, this);
      }, this);
      /*
            An index of helper methods for requiring modules within the MVC folder structure of the module.
            For example, to retrieve a module named 'foo' within the /models folder:
              foo = module.require.model('foo')
            */
      this.require = {
        model: _require('models'),
        view: _require('views'),
        controller: _require('controllers')
      };
    }
    /*
      The root view of the module (convention).
      When overriding the Module, set this property convention based proeprty within Init.
      */
    Module.prototype.rootView = null;
    /*
      Initializes the module (overridable).
      @param options
              - within: The CSS selector, DOM element, JQuery Object or [View] to initialize 
                        the module wihtin.  Passing 'options' param through the base 'init' method
                        converts whatever type of value to a jQuery element.
      */
    Module.prototype.init = function(options) {
      var get, within;
      if (options == null) {
        options = {};
      }
      get = function(fn) {
        return fn('', {
          "throw": false
        });
      };
      this.index = {
        models: get(this.require.model),
        views: get(this.require.view),
        controllers: get(this.require.controller)
      };
      within = options.within;
      if (within != null) {
        if (within instanceof jQuery) {
          ;
        } else if (within.el instanceof jQuery) {
          return options.within = within.el;
        } else if (_.isString(within) || (within instanceof HTMLElement)) {
          return options.within = $(within);
        }
      }
    };
    return Module;
  })();
}).call(this);
}, "open.client/core/mvc/template": function(exports, require, module) {(function() {
  /*
  Helper for simple client-side templates using the Underscore template engine.
  */  var Template;
  module.exports = Template = (function() {
    function Template() {
      var exclude, key, value;
      exclude = ['constructor'];
      for (key in this) {
        if (!(_(exclude).any(function(item) {
          return item === key;
        }))) {
          value = this[key];
          if (_(value).isString()) {
            this[key] = this.toTemplate(value);
          }
        }
      }
    }
    /*
      Converts a template string into a compiled template function.
      Override this to use a template library other than the default underscore engine.
      @param tmpl: The HTML template string.
      */
    Template.prototype.toTemplate = function(tmpl) {
      return new _.template(tmpl);
    };
    return Template;
  })();
}).call(this);
}, "open.client/core/mvc/view": function(exports, require, module) {(function() {
  var Model, View, common, syncVisibility;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  }, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  common = require('open.client/core/mvc/_common');
  Model = common.using('model');
  syncVisibility = function(view, visible) {
    var display;
    display = visible ? '' : 'none';
    return view.el.css('display', display);
  };
  /*
  Base class for visual controls.
  */
  module.exports = View = (function() {
    __extends(View, Model);
    /*
      Constructor.
      @param params
              - tagName   : (optional). The tag name for the View's root element (default: DIV)
              - className : (optional). The CSS class name for the root element.
              - el        : (optional). An explicit element to use.
              
      */
    function View(params) {
      var view;
      if (params == null) {
        params = {};
      }
      View.__super__.constructor.apply(this, arguments);
      this.addProps({
        enabled: true,
        visible: true
      });
      view = new Backbone.View({
        tagName: params.tagName,
        className: params.className,
        el: params.el
      });
      this._ = {
        view: view,
        atts: params
      };
      this.element = view.el;
      this.el = $(this.element);
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
}, "open.client/core/util/index": function(exports, require, module) {(function() {
  var using;
  using = function(module) {
    return require('open.client/core/util/' + module);
  };
  using('jquery');
  module.exports = {
    Property: using('property'),
    /*
      Executes a [require] call within a try/catch block.
      @param path : Path to the require statement.
      @param options
                - throw: Flag indicating if the errors should be thrown (default: false)
                - log:   Flag indicating if errors should be written to the console (default: false)
      */
    tryRequire: function(path, options) {
      var log, throwOnError, _ref, _ref2;
      if (options == null) {
        options = {};
      }
      throwOnError = (_ref = options["throw"]) != null ? _ref : options["throw"] = false;
      log = (_ref2 = options.log) != null ? _ref2 : options.log = false;
      try {
        return window.require(path);
      } catch (error) {
        if (throwOnError) {
          throw error;
        }
        if (log) {
          return typeof console !== "undefined" && console !== null ? console.log('[tryRequire] Failed to load module: ' + path) : void 0;
        }
      }
    },
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
}, "open.client/core/util/jquery": function(exports, require, module) {(function() {
  /*
  Source: http://stackoverflow.com/questions/2132172/disable-text-highlighting-on-double-click-in-jquery/2132230#2132230
  Example - No text selection on elements with a class of 'noSelect':
  
      $('.noSelect').disableTextSelect()
  
  */  $.extend($.fn.disableTextSelect = function() {
    return this.each(function() {
      if ($.browser.mozilla) {
        return $(this).css('MozUserSelect', 'none');
      } else if ($.browser.msie) {
        return $(this).bind('selectstart', function() {
          return false;
        });
      } else {
        return $(this).mousedown(function() {
          return false;
        });
      }
    });
  });
}).call(this);
}, "open.client/core/util/property": function(exports, require, module) {(function() {
  var Property, fireEvent;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  fireEvent = __bind(function(eventName, prop, args) {
    var fire;
    args.property = prop;
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
      @param options
                - silent : (optional) Flag indicating if events should be suppressed (default false).
      */
    Property.prototype.fn = function(value, options) {
      if (value !== void 0) {
        this.write(value, options);
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
      @param value : The value to write.
      @param options
                - silent : (optional) Flag indicating if events should be suppressed (default false).
      */
    Property.prototype.write = function(value, options) {
      var args, oldValue, store, _ref;
      if (options == null) {
        options = {};
      }
      if (value === void 0) {
        return;
      }
      oldValue = this.read();
      if (value === oldValue) {
        return;
      }
            if ((_ref = options.silent) != null) {
        _ref;
      } else {
        options.silent = false;
      };
      if (options.silent === false) {
        args = this.fireChanging(oldValue, value);
        if (args.cancel === true) {
          return;
        }
      }
      store = this._.store;
      if (_.isFunction(store)) {
        store(this.name, value, options);
      } else {
        store[this.name] = value;
      }
      if (options.silent === false) {
        return this.fireChanged(oldValue, value);
      }
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
