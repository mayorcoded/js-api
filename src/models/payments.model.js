'use strict';
const { Container } =  require('typedi');
const { CustomError } = require('../utils/errorHelpers');

class PaymentsModel {

    async addPayments(amount, currency, order_id, customer_id){
        try {
            const sql = Container.get('mysql'); 
            const params = [amount, currency, order_id, customer_id];
            const row = await sql.query(`INSERT into payments 
                                                (amount, currency, order_id, customer_id) 
                                         VALUES (?, ?, ?, ?)`, params);
            return row;
        } catch (error) {
            throw new CustomError({
                name: "PaymentsModelError", 
                status: 400, 
                code: "PYMTSER_OO", 
                message: error.message, 
                field: ['amount', 'currency', 'order_id', 'customer_id']
            });
        }
    }
}

Container.set('PaymentsModel', new PaymentsModel())
module.exports = PaymentsModel;