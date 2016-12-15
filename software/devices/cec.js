var CEC = require('cec_node');

var CONSTANTS = CEC.CONSTANTS;
var USER_CONTROL_CODES = CONSTANTS.USER_CONTROL_CODES;

var KEYS = {
  KEY_SELECT: USER_CONTROL_CODES.SELECT,
  KEY_UP: USER_CONTROL_CODES.UP,
  KEY_DOWN: USER_CONTROL_CODES.DOWN,
  KEY_LEFT: USER_CONTROL_CODES.LEFT,
  KEY_RIGHT: USER_CONTROL_CODES.RIGHT,
  KEY_SETUP: USER_CONTROL_CODES.SETUP,
  KEY_FAVOURITES: USER_CONTROL_CODES.FAVOURITE_MENU,
  KEY_0: USER_CONTROL_CODES.KEY_0,
  KEY_1: USER_CONTROL_CODES.KEY_1,
  KEY_2: USER_CONTROL_CODES.KEY_2,
  KEY_3: USER_CONTROL_CODES.KEY_3,
  KEY_4: USER_CONTROL_CODES.KEY_4,
  KEY_5: USER_CONTROL_CODES.KEY_5,
  KEY_6: USER_CONTROL_CODES.KEY_6,
  KEY_7: USER_CONTROL_CODES.KEY_7,
  KEY_8: USER_CONTROL_CODES.KEY_8,
  KEY_9: USER_CONTROL_CODES.KEY_9,
  KEY_DOT: USER_CONTROL_CODES.DOT,
  KEY_ENTER: USER_CONTROL_CODES.ENTER,
  KEY_CLEAR: USER_CONTROL_CODES.CLEAR,
  KEY_CHANNELUP: USER_CONTROL_CODES.CHANNEL_UP,
  KEY_CHANNELDOWN: USER_CONTROL_CODES.CHANNEL_DOWN,
  KEY_SOUND: USER_CONTROL_CODES.SOUND,
  KEY_INFO: USER_CONTROL_CODES.DISPLAY_INFO,
  KEY_HELP: USER_CONTROL_CODES.HELP,
  KEY_PAGEUP: USER_CONTROL_CODES.PAGEUP,
  KEY_PAGEDOWN: USER_CONTROL_CODES.PAGEDOWN,
  KEY_POWER: USER_CONTROL_CODES.POWER,
  KEY_VOLUMEUP: USER_CONTROL_CODES.VOLUME_UP,
  KEY_VOLUMEDOWN: USER_CONTROL_CODES.VOLUME_DOWN,
  KEY_MUTE: USER_CONTROL_CODES.MUTE,
  KEY_PLAY: USER_CONTROL_CODES.PLAY,
  KEY_STOP: USER_CONTROL_CODES.STOP,
  KEY_PAUSE: USER_CONTROL_CODES.PAUSE,
  KEY_RECORD: USER_CONTROL_CODES.RECORD,
  KEY_REWIND: USER_CONTROL_CODES.REWIND,
  KEY_FASTFORWARD: USER_CONTROL_CODES.FAST_FORWARD,
  KEY_EJECTCD: USER_CONTROL_CODES.EJECT,
  KEY_FORWARD: USER_CONTROL_CODES.FORWARD,
  KEY_BACKWARD: USER_CONTROL_CODES.BACKWARD,
  KEY_ANGLE: USER_CONTROL_CODES.ANGLE,
  KEY_EPG: USER_CONTROL_CODES.EPG,
  KEY_BLUE: USER_CONTROL_CODES.BLUE,
  KEY_RED: USER_CONTROL_CODES.RED,
  KEY_GREEN: USER_CONTROL_CODES.GREEN,
  KEY_YELLOW: USER_CONTROL_CODES.YELLOW,
  KEY_STANDBY: USER_CONTROL_CODES.POWER_OFF_FUNCTION
}

function CECDevice(cec, device, address, overrides) {
  this.cec = cec;
  this.source = 1;
  this.destination = address;
  this.overrides = {};

  for(var key in overrides) {
    this.overrides[key] = require("../" + overrides[key]);
  }
}

CECDevice.initialize = function(config, cb) {
  var devices = {}
  var cec = CEC.start({ name: 'ir-blaster' });

  for(var i = 0; i < config.devices.length; i++) {
    var device = config.devices[i];
    var receiver = new CECDevice(cec, device.name, device.address, device.overrides);
    devices['cec-' + device.name] = receiver;
  }

  cb(null, devices);
}

CECDevice.prototype.buildCode = function(opcode, data) {
  return this.source + "" + this.destination + ":" + opcode + (data ? ":" + data : "");
}

CECDevice.prototype.list = function(callback) {
  var keys = [];
  for(var key in KEYS) {
    keys.push(key);
  }
  for(var key in this.overrides) {
    keys.push(key);
  }

  callback(null, keys);
}

CECDevice.prototype.sendOnce = function(key, cb) {
  var context = this;
  this.sendStart(key, function(error, data) {
    if(error) {
      cb(error);
      return;
    }
    setTimeout(function() {
      context.sendStop(key, cb);
    }, 100);
  });
}

function formatHex(num) {
  return ("00" + num.toString(16)).substr(-2);
}

CECDevice.prototype.sendStart = function(key, cb) {
  if(this.overrides[key]) {
    this.overrides[key].call(this, key, cb);
  } else {
    var code = this.buildCode(44, formatHex(KEYS[key]));
    this.cec.send(code, cb)
  }
}

CECDevice.prototype.sendStop = function(key, cb) {
  var code = this.buildCode(45);
  this.cec.send(code, cb)
}

CECDevice.prototype.status = function(status, cb) {
  cb("Not supported");
}

CECDevice.prototype.statuses = function(cb) {
  cb(null, []);
}

module.exports = CECDevice;
