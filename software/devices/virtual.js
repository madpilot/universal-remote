var fs = require('fs');

function VirtualDevice(input) {
  function Inner(config) {
    this.config = config;
    this.input = input;
  }

  Inner.initialize = function(config, cb) {
    fs.readFile(config, function(error, data) {
      if(error) {
        cb(error);
        return;
      }

      var device = {};
      var virtual = JSON.parse(data);
      device[virtual.name] = new Inner(config);
      return device;
    });
  }

  Inner.prototype.list = function(cb) {
    var keys = [];
    for(var key in this.config.macros) {
      keys.push(key);
    }
    cb(null, keys);
  }

  Inner.prototype.sendOnce = function(key, cb) {
    this.input.invoke(this.config.macros[key], cb);
  }

  Inner.prototype.sendStart = function(key, cb) {
    // TODO, track which are started, and manually repeat
    this.input.invoke(this.config.macros[key], cb);
  }

  Inner.prototype.sendStop = function(key) {
    this.input.invoke(this.config.macros[key], cb);
  }

  Inner.prototype.status = function(status, cb) {
    cb("Not supported");
  }

  Inner.prototype.statuses = function(cb) {
    cb(null, []);
  }

  return Inner;
}

module.exports = VirtualDevice;
