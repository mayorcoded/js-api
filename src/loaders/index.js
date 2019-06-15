'use strict'; 
const EventEmitter = require('events').EventEmitter;
const expressLoader = require('./express');
const mysqlLoader = require('./database');
const jobLoader = require('./jobs');
const dependencyInjector = require('./dependencyInjector');
const welcomeService = require('../services/welcome');
const customerService = require('../services/customers.service');
const productService = require('../services/products.service');
const shoppingcartService = require('../services/shoppingcart.service');
const shippingService = require('../services/shipping.service');
const taxService = require('../services/tax.service');
const departmentService = require('../services/deparments.service');
const categoryService = require('../services/categories.service');
const attributeService = require('../services/attributes.service');
const orderService = require('../services/orders.service');
const paymentService = require('../services/payments.service');
const emailService = require('../services/email.service');
const logger = require('../utils/winston');
const flatCache = require("flat-cache");
const path = require("path");
const Queue = require("bull");


//load models
require('../models/customers.model');
require('../models/products.model');
require('../models/shoppingcart.model');
require('../models/tax.model');
require('../models/shipping.model');
require('../models/departments.model');
require('../models/categories.model');
require('../models/attributes.model');
require('../models/orders.model');
require('../models/payments.model');

module.exports = async (expressApp) => {
     /**
     * Load mysql into dependency injector
     */
    const mysqlConnection = await mysqlLoader();
    console.log('✌️ DB loaded and connected!');

    /**
     * Load cache into dependency injector
     */
    const cache = flatCache.load("cache", path.resolve("./cache"));
    console.log('✌️ Cache loaded and buzzing!');

    /**
     * Load events
     */
    const eventEmitter = new EventEmitter();
    const customerEvents = eventEmitter;
    const paymentEvents = eventEmitter;
    const orderEvents = eventEmitter;
    console.log('✌️ Events producers loaded!');

    /**
     * Load Queues
     */
    const emailQueue = new Queue('email-queue', "redis://127.0.0.1:6379");

    /**
     * Load all service instances into dependency injector
     */
    const dependencies = [
        { name: 'logger', service: logger },
        { name: 'welcome', service: new welcomeService() },
        { name: 'customerService', service: new customerService() },
        { name: 'productService', service: new productService() },
        { name: 'shoppingcartService', service: new shoppingcartService() },
        { name: 'taxService', service: new taxService() },
        { name: 'shippingService', service: new shippingService() },
        { name: 'departmentService', service: new departmentService() },
        { name: 'categoryService', service: new categoryService() },
        { name: 'attributeService', service: new attributeService() },
        { name: 'orderService', service: new orderService()},
        { name: 'paymentService', service: new paymentService()},
        { name: 'mysql', service: mysqlConnection },
        { name: 'cache', service: cache },
        { name: 'customerEvents', service: customerEvents},
        { name: 'paymentEvents', service: paymentEvents},
        { name: 'orderEvents', service: orderEvents},
        { name: 'emailService', service: new emailService()},
        { name: 'emailQueue', service: emailQueue}
    ]
    await dependencyInjector(dependencies);
    console.log('✌️ Dependency Injector loaded');

    /**
     * Load Event Subscribers 
     */
    require('../subscribers/customer.subscriber');
    require('../subscribers/order.subscriber');
    require('../subscribers/payment.subscriber');

    /**
     * Load Jobs into dependency injector
     */
    await jobLoader();

    /**
     * Load Express
     */
    await expressLoader(expressApp);
    console.log('✌️ Express loaded');
}