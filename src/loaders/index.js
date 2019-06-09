'use strict';
const expressLoader = require('./express');
const mysqlLoader = require('./database');
const jobLoader = require('./jobs');
const dependencyInjector = require('./dependencyInjector');
const welcomeService = require('../services/welcome');
const customerService = require('../services/customers.service');
const productService = require('../services/products.service');
const shoppingcartService = require('../services/shoppingcart.service');
const taxService = require('../services/tax.service');
const logger = require('../utils/winston');
const flatCache = require("flat-cache");
const path = require("path");

//load models
require('../models/customers.model');
require('../models/products.model');
require('../models/shoppingcart.model');
require('../models/tax.model');

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
     * Load all service instances into dependency injector
     */
    const dependencies = [
        { name: 'welcome', service: new welcomeService() },
        { name: 'customerService', service: new customerService() },
        { name: 'productService', service: new productService() },
        { name: 'shoppingcartService', service: new shoppingcartService() },
        { name: 'taxService', service: new taxService() },
        { name: 'mysql', service: mysqlConnection },
        { name: 'logger', service: logger },
        { name: 'cache', service: cache }
    ]
    await dependencyInjector(dependencies);
    console.log('✌️ Dependency Injector loaded');

    /**
     * Load Jobs into dependency injector
     */
    await expressLoader(expressApp);
    console.log('✌️ Express loaded');
}