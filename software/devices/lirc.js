var irsend = require('lirc_node').irsend;

function LIRCDevice(device) {
  this.device = device;
}

LIRCDevice.initialize = function(device, cb) {
  var names = [];
  if(device.discover) {
    names = LIRCDevice.devices(function(error, names) {
      var devices = {};
      for(var j = 0; j < names.length; j++) {
        var name = names[j].toLowerCase().replace(/(^[a-z0-9])/, '-');
        console.log(name);
        var receiver = new LIRCDevice(names[j]);
        devices["lirc:" + names[j]] = receiver;
      }
      cb(null, devices);
    });
  } else {
    // Manually iterate and create objects
  }
}

LIRCDevice.devices = function(callback) {
  irsend.list("", "", function(_, _, result) {
    var lines = result.split("\n");

    var devices = [];
    for(var i = 0; i < lines.length; i++) {
      if(lines[i].length > 0) {
        console.log(lines[i]);
        var parts = lines[i].split(' ');
        devices.push(parts[2]);
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

LIRCDevice.prototype.status = function(status) {
  cb("Not supported");
}

LIRCDevice.prototype.statuses = function(status) {
  cb(null, []);
}

module.exports = LIRCDevice;
