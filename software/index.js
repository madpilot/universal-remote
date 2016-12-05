var config = require('./config.json');

var deviceDrivers = {
  lirc: require('./devices/lirc.js')
};

var inputDrivers = {
  http: require('./inputs/http.js')
}

var inputs = [];
for(var i = 0; i < config.inputs.length; i++) {
  var input = config.inputs[i];
  if(input.driver == "http") {
    var server = new inputDrivers.http(input.config);
    inputs.push(server);
  }
}

var devices = {};
for(var i = 0; i < config.devices.length; i++) {
  var device = config.devices[i];
  if(device.driver == "lirc") {
    var receiver = new deviceDrivers.lirc(device.id);
    devices[device.id] = receiver;
  }
}

var handler = function(device, event, key, cb) {
  if(typeof devices[device] != "undefined") {
    switch(event) {
      case 'sendOnce':
        devices[device].sendOnce(key, cb);
        break;
      case 'sendStart':
        devices[device].sendStart(key, cb);
        break;
      case 'sendStop':
        devices[device].sendStop(key, cb);
        break;
      case 'list':
        devices[device].list(cb);
        break;
    }
  }
}

for(var i = 0; i < inputs.length; i++) {
  inputs[i].listen(handler);
}


