const { Router } = require('express');
const welcome = require('./routes/welcome');
const customerRoute = require('./routes/customers.route');
const productsRoute = require('./routes/products.route');
const shoppingcartRoute = require('./routes/shoppingcart.route');
const taxRoute = require('./routes/tax.route');
const shippingRoute = require('./routes/shipping.route');
const departmentsRoute = require('./routes/departments.route');
const categroryRoute = require('./routes/categories.route');
const attributeRoute = require('./routes/attributes.routes');
const ordersRoute = require('./routes/orders.route');
const paymentsRoute = require('./routes/payments.routes');

const app = Router();
welcome(app);
customerRoute(app);
productsRoute(app);
shoppingcartRoute(app);
shippingRoute(app);
taxRoute(app);
departmentsRoute(app);
categroryRoute(app);
attributeRoute(app);
ordersRoute(app);
paymentsRoute(app);

module.exports = app;