const helmet = require('helmet');
const hpkp = require('hpkp');
const rateLimit = require('express-rate-limit');

const ninetyDaysInSeconds = 7776000;
const hpkpOptions = {
    maxAge: ninetyDaysInSeconds,
    sha256s: ["AbCdEf123=", "ZyXwVu456="],
};
const rateLimitIp = new rateLimit({
    windowMs: 15 * 60 * 1000,
    max: 100,
    delayMs: 0
});

const helmetOptions = {
    expectCt:{
        enforce: true,
        maxAge: 123
    },
    contentSecurityPolicy: {
        directives: {
            defaultSrc: ["'self'"]
        }
    }
};

function secureRoutes(app) {
    app.enable("trust proxy");
    app.use(helmet());
    app.use(helmet.xssFilter());
    app.use(helmet.expectCt(helmetOptions.expectCt));
    app.use(helmet.contentSecurityPolicy(helmetOptions.contentSecurityPolicy));
    app.use(hpkp(hpkpOptions));
    app.use(rateLimitIp);
}

module.exports = secureRoutes;