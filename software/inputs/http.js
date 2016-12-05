var logger = require('winston');
var express = require('express')
var bodyParser = require('body-parser');

var app = express();
app.use(bodyParser.urlencoded({
  extended: true
}));
app.use(bodyParser.json());

function HttpInput(config) {
  this.config = config;
  this.bind = config.bind || "0.0.0.0";
  this.port = config.port || 80;
}

function setHeaders(res) {
  res.setHeader('Content-Type', 'application/json');
}

function returnError(res, error) {
  res.status(500);
  res.send(JSON.stringify({ error: error }));
}

HttpInput.prototype.listen = function(handler) {
  var context = this;
  app.get("/list/:device/", function(req, res) {
    handler(req.params.device, "list", null, function(error, keys) {
      setHeaders(res);
      if(error != null) {
        returnError(res, error);
      } else {
        res.send(JSON.stringify(keys));
      }
    });
  });

  app.put("/send/:device", function(req, res) {
    handler(req.params.device, "sendOnce", req.body.key, function(error, success) {
      setHeaders(res);
      if(error != null) {
        returnError(res, error);
      } else {
        res.send(JSON.stringify({ status: "OK" }));
      }
    });
  });

  app.put("/start/:device/:key", function(req, res) {
    handler(req.params.device, "sendStart", req.params.key, function(error, success) {
      setHeaders(res);
      if(error != null) {
        returnError(res, error);
      } else {
        res.send(JSON.stringify({ status: "OK" }));
      }
    });
  });

  app.put("/stop/:device/:key", function(req, res) {
    handler(req.params.device, "sendStop", req.params.key, function(error, success) {
     setHeaders(res);
      if(error != null) {
        returnError(res, error);
      } else {
        res.send(JSON.stringify({ status: "OK" }));
      }
    });
  });

  app.listen(this.port, function() {
    logger.info("HTTP API listening on " + context.bind + ":" + context.port);
  });
}

module.exports = HttpInput;
