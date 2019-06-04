'use strict';
const { Container } =  require('typedi');
const { CustomError } = require('../utils/errorHelpers');

class CustomerModel {
    async getCustomer(column, value){
        try {
            const sql = Container.get('mysql'); 
            const row = await sql.query(`select * from customer where ${column} = ?`, value);
            return row;
        } catch (error) {
            throw new CustomError({ 
                name: "CustomerModelError", 
                status: 400, 
                code: "MDLR_OO", 
                message: error.message, 
                field: "email" 
            });
        }
    }

    async addCustomerToDb(customer){
        try {
            let columns = '(';
            const params = [];
            let placeHolders = '(';
            const sql = Container.get('mysql');

            for (const key in customer){
                params.push(customer[key]);
                columns += `${key}, `;
                placeHolders += `?, `;
            }

            columns = columns.slice(0, columns.length - 2) + ')';
            placeHolders = placeHolders.slice(0, placeHolders.length - 2) + ')';

            const row = await sql.query(`INSERT INTO customer ${columns} VALUES ${placeHolders}`, params);
            return row;
        } catch (error) {
            throw new CustomError({ 
                name: "CustomerModelError", 
                status: 400, 
                code: "MDLR_O1", 
                message: error.message, 
                field: "body" 
            });
        }
    }

    async updateCustomer(customer, customerId){
        try {
            let conditions = "";
            const params = [];
            const sql = Container.get('mysql');

            for (const key in customer) {
                params.push(customer[key]);
                conditions += `${key} = ?, `;
            }

            params.push(customerId);
            const query = "UPDATE customer SET " + conditions.slice(0, conditions.length - 2) + " WHERE customer_id = ?";
            const row = await sql.query(query, params);
            
            return {query, params, row};

        } catch (error) {
            throw new CustomError({
                name: "CustomerModelError", 
                status: 400, 
                code: "MDLR_O2", 
                message: error.message, 
                field: "body" 
            })
        }
    }
}

Container.set('customerModel', new CustomerModel())
module.exports = CustomerModel;