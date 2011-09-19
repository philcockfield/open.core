(function() {
    if (!this.require) {
        var modules = {},
        cache = {},
        require = function(name, root) {
            var path = expand(root, name), 
                cacheKey = path,
                module = cache[cacheKey],
                fn;
            if (module) {
                return module;
            } else if (fn = modules[path] || modules[path = expand(path, './index')]) {
                module = {
                    id: path,
                    exports: {}
                };
                try {
                    cache[cacheKey] = module.exports;
                    fn(module.exports,
                    function(name) {
                        return require(name, dirname(path));
                    },
                    module);
                    return cache[cacheKey] = module.exports;
                } catch(err) {
                    delete cache[cacheKey];
                    throw err;
                }
            } else {
                throw 'module \'' + name + '\' not found';
            }
        },
        expand = function(root, name) {
            var results = [],
            parts,
            part;
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
        },
        dirname = function(path) {
            return path.split('/').slice(0, -1).join('/');
        };
        this.require = function(name) {
            return require(name, '');
        };
        this.require.define = function(bundle) {
            for (var key in bundle)
            modules[key] = bundle[key];
        };
    }
    return this.require.define;
}).call(this);
