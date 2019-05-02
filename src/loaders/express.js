const bodyParser =  require('body-parser');
const cors =  require('cors');
const expressValidator =  require('express-validator');
const compression =  require('compression');
const responseTime =  require('response-time');
const latencyHeaders =  require('express-latency-headers');
const morgan =  require('morgan');
const winston =  require('../utils/winston');
const {secureRoutes} = require('../api/middlewares');

const routes = require('../api');

const config  = require('../config');

 module.exports = async(expressApp) => {
    const app = expressApp;

    //Health Check Endpoints
    app.get('/status', (req, res) => { res.status(200).end(); });
    app.head('/status', (req, res) => { res.status(200).end(); });

    //set response content type
    app.use((req, res, next) => {
        res.setHeader("Content-Type", "application/json");
        next();
    });

    //secure routes
    secureRoutes(app)

    // If app is behind a reverse proxy (Heroku, Bluemix, AWS ELB, Nginx, etc)
    // It shows the real origin IP in the heroku or Cloudwatch logs
    app.enable('trust proxy'); 

    // Enable Cross Origin Resource Sharing to all origins by default
    app.use(cors());
     
    // "Lets you use HTTP verbs such as PUT or DELETE in places where the client doesn't support it."
    app.use(require('method-override')());

    // Middleware that transforms the raw string of req.body into json 
    app.use(bodyParser.json());
    app.use(bodyParser.urlencoded({extended: true}));

    //track api latency
    app.use(latencyHeaders());

    //validate request body
    app.use(expressValidator());

    //compress response
    app.use(compression());

    //track response time
    app.use(responseTime());

    // Load API routes
    app.use(config.api.prefix, routes)

    // Add some logging
    app.use(morgan('combined', { stream: winston.stream }));

    // catch 404 and forward to error handler
    app.use((req, res, next) => {
        const err = new Error('Route Not Found') 
        err.status = 404;
        err.customCode = 'RNF_01';
        err.field = 'api path'
        next(err);
    });

    /// error handlers
    app.use((err, req, res, next) => {
        /**
         * Handle 401 thrown by express-jwt library
         */
        if (err.name === 'UnauthorizedError') {
            return res.status(err.status).send({
                "error": {
                    status: 401,
                    code: "AUT_02",
                    message: err.message,
                    field: "token"
                }
            }).end();
        }
        return next(err);
    });
    app.use((err, req, res, next) => {
        res.status(err.status || 500);
        res.json({
            "error": {
                status: err.status,
                code: err.customCode,
                message: err.message,
                field: err.field
            }
        });
    });
}