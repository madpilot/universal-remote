var irsend = require('lirc_node').irsend;

function LIRCDevice(device) {
  this.device = device;
}

LIRCDevice.prototype.setup = function() {}
LIRCDevice.prototype.tearDown = function() {}

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
    callback(keys);
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

module.exports = LIRCDevice;
