const { Router } = require('express');
const welcome = require('./routes/welcome');
const customerRoute = require('./routes/customers.route');

const app = Router();
welcome(app);
customerRoute(app);

module.exports = app;