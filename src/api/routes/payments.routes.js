'use strict';
const { Router } = require('express');
const { Container } =  require('typedi');
const { verifyToken } = require('../../api/middlewares');
const { validationResult } = require("express-validator/check");
const { validateNewPayment} = require('../../utils/validators');
const { filterError, CustomError} = require('../../utils/errorHelpers'); 

const route = Router()

module.exports = async(app) => {
    app.use(route);
    
    route.post('/stripe/charge', verifyToken, validateNewPayment, async (req, res, next) => {
        const errors = filterError(validationResult(req));

        if (errors) {
            const error = new CustomError({ 
                name: "PaymentsError", 
                status: 422, 
                code: "PAYERR_00", 
                message: "failed to make payments for order", 
                field: [errors]
            });

            return next(error);
        }

        try {
            const customerId = req.decoded.id;
            const {amount, currency, order_id, description} = req.body;
            const paymentService = Container.get('paymentService');
            const response = await paymentService.makePayments(amount,currency,order_id,customerId,description);
            return res.json(response);
        } catch (error) {
            return next(error);
        }
    });

    route.post('/stripe/webhooks', async (req, res, next) => {
        return res.json('This endpoint is used by Stripe.');
    });
}