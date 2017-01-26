function DummyDevice() {}

DummyDevice.initialize = function(config, cb) {
  var devices = { dummy: new DummyDevice() };
  cb(null, devices);
}

DummyDevice.prototype.list = function(callback) {
  callback(null, [ 'KEY_POWER', 'KEY_STANDBY', 'KEY_VOLUMEUP', 'KEY_VOLUMEDOWN' ]);
}

DummyDevice.prototype.sendOnce = function(key, cb) {
  cb(null, true);
}

DummyDevice.prototype.sendStart = function(key, cb) {
  cb(null, true);
}

DummyDevice.prototype.sendStop = function(key, cb) {
  cb(null, true);

}

DummyDevice.prototype.status = function(status, cb) {
  cb("Not supported");
}
DummyDevice.prototype.statuses = function(cb) {
  cb(null, []);
}

module.exports = DummyDevice;
