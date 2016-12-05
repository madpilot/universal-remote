var config = require('./config.json');
var deviceDrivers = {
  LIRC: require('./devices/lirc.js')
};

var devices = {};

for(var i = 0; i < config.devices.length; i++) {
  var device = config.devices[i];
  if(device.driver == "lirc") {
    var receiver = new deviceDrivers.LIRC(device.id);
    receiver.setup();
    devices[device.id] = receiver;
  }
}
