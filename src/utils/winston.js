const appRoot = require('app-root-path');
const winston = require('winston');

// define the custom settings for each transport (file, console)
const options = {
    file: {
        level: 'info',
        filename: `${appRoot}/src/logs/app.log`,
        handleExceptions: true,
        json: true,
        maxsize: 5242880, // 5MB
        maxFiles: 5,
        colorize: false,
    },
    console: {
        level: 'debug',
        handleExceptions: true,
        json: false,
        colorize: true,
    },
};

// create a new logger with the custom settings
const logger = new winston.createLogger({
    transports: [
        new winston.transports.File(options.file),
        new winston.transports.Console(options.console)
    ],
    exitOnError: false, // do not exit on handled exceptions
});

logger.stream = {
    write: function(message, encoding) {
        logger.info(message);
    },
};

module.exports = logger;