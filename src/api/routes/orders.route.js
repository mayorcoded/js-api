'use strict';

const { Router } = require('express');
const { Container } =  require('typedi');
const { verifyToken } = require('../../api/middlewares');
const { validationResult } = require("express-validator/check");
const { filterError, CustomError} = require('../../utils/errorHelpers');
const { validateNewOrder} = require('../../utils/validators');

const route = Router()

module.exports = async(app) => {
    app.use(route);
    
    route.post('/orders', verifyToken, validateNewOrder, async (req, res, next) => {
        const errors = filterError(validationResult(req));

        if (errors) {
            const error = new CustomError({ 
                name: "OrdersError", 
                status: 422, 
                code: "ORDERR_00", 
                message: "failed to place order for items", 
                field: [errors]
            });

            return next(error);
        }

        try {
            const customerId = req.decoded.id;
            const {cart_id, shipping_id, tax_id} = req.body;
            const orderService = Container.get('orderService');
            const response = await orderService.addOrder(cart_id,shipping_id,tax_id,customerId);
            return res.json(response);
        } catch (error) {
            return next(error);
        }
    });

    route.get('/orders/:order_id([0-9]+)', verifyToken, async (req, res, next) => {
        try {
            const {order_id} = req.params;
            const orderService = Container.get('orderService');
            const response = await orderService.getOrderDetails(order_id);
            return res.json(response);
        } catch (error) {
            return next(error);
        }
    });

    route.get('/orders/inCustomer', verifyToken, async (req, res, next) => {
        try {
            const customerId = req.decoded.id;
            const orderService = Container.get('orderService');
            const response = await orderService.getCustomerOrders(customerId);
            return res.json(response);
        } catch (error) {
            return next(error);
        }
    });

    route.get('/orders/shortDetail/:order_id([0-9]+)', verifyToken, async (req, res, next) => {
        try {
            const {order_id} = req.params;
            const orderService = Container.get('orderService');
            const response = await orderService.getOrder(order_id);
            return res.json(response);
        } catch (error) {
            return next(error);
        }
    });
}