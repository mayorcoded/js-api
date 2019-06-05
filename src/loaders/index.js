'use strict';
const expressLoader = require('./express');
const mysqlLoader = require('./database');
const jobLoader = require('./jobs');
const dependencyInjector = require('./dependencyInjector');
const welcomeService = require('../services/welcome');
const customerService = require('../services/customers.service');
const productService = require('../services/products.service');
const logger = require('../utils/winston');

//load models
require('../models/customers.model');
require('../models/products.model');

module.exports = async (expressApp) => {
    const mysqlConnection = await mysqlLoader();
    console.log('✌️ DB loaded and connected!');

    /**
     * Load all service instances into dependency injector
     */
    const dependencies = [
        { name: 'welcome', service: new welcomeService() },
        { name: 'customerService', service: new customerService() },
        { name: 'productService', service: new productService() },
        { name: 'mysql', service: mysqlConnection },
        { name: 'logger', service: logger }
    ]
    await dependencyInjector(dependencies);
    console.log('✌️ Dependency Injector loaded');

    /**
     * Load Jobs into dependency injector
     */
    await expressLoader(expressApp);
    console.log('✌️ Express loaded');
}