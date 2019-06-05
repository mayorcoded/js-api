const { Router } = require('express');
const welcome = require('./routes/welcome');
const customerRoute = require('./routes/customers.route');
const productsRoute = require('./routes/products.route');

const app = Router();
welcome(app);
customerRoute(app);
productsRoute(app);

module.exports = app;