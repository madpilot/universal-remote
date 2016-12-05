var express = require('express')
var bodyParser = require('body-parser');

var app = express();
app.use(bodyParser.urlencoded({
  extended: true
}));
app.use(bodyParser.json());

function HttpInput(config) {
  this.config = config;
}

HttpInput.prototype.listen = function(handler) {
  app.get("/list", function(req, res) {
    res.send("list");
  });

  app.get("/list/:device/", function(req, res) {
    handler(req.params.device, "list", null, function(error, keys) {
      if(error != null) {
        res.send(error);
        return;
      }
      res.send(JSON.stringify(keys));
    });
  });

  app.put("/send/:device", function(req, res) {
    handler(req.params.device, "sendOnce", req.body.key, function(error, success) {
      if(error != null) {
        res.send(error);
        return;
      }
      res.send("OK");
    });
  });

  app.put("/start/:device/:key", function(req, res) {
    handler(req.params.device, "sendStart", req.params.key, function(error, success) {
      if(error != null) {

        return;
      }

    });
  });

  app.put("/stop/:device/:key", function(req, res) {
    handler(req.params.device, "sendStop", req.params.key, function(error, success) {
      if(error != null) {

        return;
      }

    });
  });

  app.listen(this.config.port || 80, function() {

  });
}

module.exports = HttpInput;
