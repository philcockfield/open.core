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
}).call(this)({"base": function(exports, require, module) {(function() {
  /*
  Common base class.
  */  var Base;
  module.exports = Base = (function() {
    function Base() {
      _.extend(this, Backbone.Events);
    }
    /*
      Common utility functionality for the class.
      */
    Base.prototype.util = {
      merge: function(source, target) {
        return _.extend(target != null ? target : target = {}, source != null ? source : source = {});
      }
    };
    return Base;
  })();
}).call(this);
}, "core.client": function(exports, require, module) {(function() {
  module.exports = {
    title: 'Open.Core (Client)',
    Base: require('./base'),
    mvc: require('./mvc/index')
  };
}).call(this);
}, "mvc/index": function(exports, require, module) {(function() {
  module.exports = {
    View: require('./view'),
    Template: require('./template')
  };
}).call(this);
}, "mvc/template": function(exports, require, module) {(function() {
  /*
  Helper for simple client-side templates using the Underscore template engine
  in must Mustache mode.
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
}, "mvc/view": function(exports, require, module) {(function() {
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
}});
