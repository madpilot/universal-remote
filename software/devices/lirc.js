var irsend = require('lirc_node').irsend;

function LIRCDevice(device) {
  this.device = device;
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
