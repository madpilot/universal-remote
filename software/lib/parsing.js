var options = require('options-parser');

var result = options.parse({
  config: { 
		short: 'c', 
		help: "Path to the config file",
    type: options.type.file.open.read()
  },
	help: {
    short: "h",
    help: "This help screen",
    showHelp: { 
      banner: "universal-remote -c <config file>"
    }
  }
}, function(err) {
  if(err.required) {
    logger.error("Option -" + err.required + " missing required argument");	
  }

  if(err.missing) {
    logger.error("Option -" + err.missing + " is required");	
  }
  if(err.validation) {
    logger.error("Could not open config file");
  }

  process.exit(1);
});

if(result.opt.config == null) {
  logger.error("Option -c is required");	
	process.exit(1);
}

module.exports = result;
