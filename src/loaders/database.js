"use strict";
const mysql = require('promise-mysql');
const config = require('../config');
let connection;

async function dbConnection(){
    try {
        connection = await mysql.createPool({
            host: config.db_host, 
            user: config.db_user, 
            password: config.db_password, 
            database: config.db_name,
            connectionLimit: 10
        });
        return connection;
    } catch (error) {
        console.error(error);
        process.exit(1)
    }
}

module.exports = dbConnection;



   
    

