'use strict';
const expressLoader = require('./express');
const mysqlLoader = require('./database');
const jobLoader = require('./jobs');
const dependencyInjector = require('./dependencyInjector');
const welcomeService = require('../services/welcome');
const logger = require('../utils/winston');

module.exports = async (expressApp) => {
    const mysqlConnection = await mysqlLoader();
    console.log('✌️ DB loaded and connected!');

    /**
     * Load all service instances into dependency injector
     */
    const dependencies = [
        { name: 'welcome', service: new welcomeService() },
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