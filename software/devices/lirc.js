var irsend = require('lirc_node').irsend;

function LIRCDevice(device) {
  this.device = device;
}

function buildObjects(names) {
  var devices = {};

  for(var i = 0; i < names.length; i++) {
    if(names[i]) {
      var name = names[i].toLowerCase().replace(/[^(a-z0-9)]/, '-').replace('--', '-');
      var receiver = new LIRCDevice(name);
      devices["lirc-" + name] = receiver;
    }
  }
  return devices;
}

LIRCDevice.initialize = function(config, cb) {
  var names = [];
  if(config.discover) {
    LIRCDevice.devices(function(error, names) {
      if(error == null) {
        cb(null, buildObjects(names));
      } else {
        cb(error);
      }
    });
  } else {
    if(config.names) {
      cb(null, buildObjects(config.names));
    }
  }
}

LIRCDevice.devices = function(callback) {
  irsend.list("", "", function(_, _, result) {
    var lines = result.split("\n");

    var devices = [];
    for(var i = 0; i < lines.length; i++) {
      if(lines[i].length > 0) {
        var parts = lines[i].split(' ');
        devices.push(parts[1]);
      }
    }
    callback(null, devices);
  });
}

LIRCDevice.prototype.list = function(callback) {
  irsend.list(this.device, "", function(_, _, result) {
    var lines = result.split("\n");

    var keys = [];
    for(var i = 0; i < lines.length; i++) {
      if(lines[i].length > 0) {
        var parts = lines[i].split(' ');
        keys.push(parts[2]);
      }
    }
    callback(null, keys);
  });
}

LIRCDevice.prototype.sendOnce = function(key, cb) {
  irsend.send_once(this.device, key, function() {
    cb(null, true);
  });
}

LIRCDevice.prototype.sendStart = function(key) {
  irsend.send_start(this.device, key, function() {
    cb(null, true);
  });
}

LIRCDevice.prototype.sendStop = function(key) {
  irsend.send_stop(this.device, key, function() {
    cb(null, true);
  });
}

LIRCDevice.prototype.status = function(status, cb) {
  cb("Not supported");
}

LIRCDevice.prototype.statuses = function(cb) {
  cb(null, []);
}

module.exports = LIRCDevice;
