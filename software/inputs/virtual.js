function VirtualInput() {
  this.hander = null;
};

VirtualInput.prototype.listen = function(handler) {
  this.handler = handler;
}

VirtualInput.prototype.invoke = function(macros, cb) {
  if(this.handler == null) {
    cb();
  }

  var index = -1;
  var results = [];

  function waterfall(error, result) {
    index++;

    if(index == macros.length) {
      cb(null, results);
      return;
    }

    if(error) {
      cb(error);
      return;
    }

    if(results != null) {
      results.push(result);
    }

    var macro = macros[index].split('/');
    var event = macro[0];
    var device = macro[1];
    var key = macro[2];

    if(event == "delay") {
      setTimeout(function() {
        waterfall();
      }, device);
    } else {
      this.handler(device, event, key, waterfall);
    }
  }

  waterfall();
}

VirtualInput.prototype.list = function(cb) {}

module.exports = VirtualInput;
