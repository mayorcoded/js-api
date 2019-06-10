'use strict';
const { Container } =  require('typedi');
const config = require('../config');
const stripe = require("stripe")(config.stripe.api_key);

class PaymentService {
    async makePayments(amount, currency, order_id, customer_id, description){
        try {
            currency = currency || 'USD';
            const paymentsModel = Container.get('PaymentsModel');
            const payments = await stripe.charges.create({
                amount: amount,
                currency: currency,
                source: 'tok_mastercard',
                description: description
            });
            
            await paymentsModel.addPayments(amount,currency,order_id,customer_id);
            return payments;
        } catch (error) {
            throw error;
        }
    }
}

module.exports = PaymentService;