var logger = require('winston');

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
    logger.info("Loading the http input driver");
    var server = new inputDrivers.http(input.config);
    inputs.push(server);
  }
}

var devices = {};
for(var i = 0; i < config.devices.length; i++) {
  var device = config.devices[i];
  if(device.driver == "lirc") {
    logger.info("Loading " + device.id + " using the lirc device driver");
    var receiver = new deviceDrivers.lirc(device.id);
    devices[device.id] = receiver;
  }
}

var handler = function(device, event, key, cb) {
  if(device == null) {
    logger.info("Listing devices");
    var ids = [];
    
    for(var id in devices) {
      ids.push(id);
    }
    
    cb(null, ids);
    return;
  }
  
  if(typeof devices[device] != "undefined") {
    switch(event) {
      case 'sendOnce':
        logger.info("Sending " + key + " to " + device);
        devices[device].sendOnce(key, cb);
        break;
      case 'sendStart':
        logger.info("Starting " + key + " on " + device);
        devices[device].sendStart(key, cb);
        break;
      case 'sendStop':
        logger.info("Stopping " + key + " on " + device);
        devices[device].sendStop(key, cb);
        break;
      case 'list':
        logger.info("Listing keys on " + device);
        devices[device].list(cb);
        break;
    }
  }
}

for(var i = 0; i < inputs.length; i++) {
  inputs[i].listen(handler);
}
