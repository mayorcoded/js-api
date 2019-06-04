'use strict';
const { Router } = require('express');
const { 
    validateNewCustomer, 
    validateLogin, 
    validateUpdateCustomer, 
    validateUpdateCustomerAddress, 
    validateUpdateCustomerCreditCard,
    validateFacebookLogin
} = require('../../utils/validators')
const { filterError, CustomError} = require('../../utils/errorHelpers')
const { validationResult } = require("express-validator/check");
const { Container } =  require('typedi');
const { verifyToken } = require('../../api/middlewares');

const route = Router();
const passport = require('passport');
const configureFacebook = require('../../config/facebook.config');


module.exports = async (app) => {
    app.use(route);
    configureFacebook();

    const checkAccessTokenOrThrow = (req, res, next) => {                
        const errors = filterError(validationResult(req));

        if (errors) {
            const error = new CustomError({ 
                name: "FacebookLoginError", 
                status: 422, 
                code: "USR_02", 
                message: "unable to login with facebook", 
                field: [errors]
            });

            return next(error);
        }
        next();
    };

    /**
     * POST Request
     */
    route.post('/customers', validateNewCustomer , async (req, res, next) => {
        const errors = filterError(validationResult(req));

        if (errors) {
            const error = new CustomError({ 
                name: "RegistrationError", 
                status: 422, 
                code: "USR_00", 
                message: "unable to register customer", 
                field: [errors]
            });

            return next(error);
        }

        try {
            const customerService = Container.get('customerService');
            const response = await customerService.register(req.body);
            return res.json(response);
        } catch (error) {
            return next(error);
        }
    });

    route.post('/customers/login', validateLogin, async (req, res, next) => {
        const errors = filterError(validationResult(req));

        if (errors) {
            const error = new CustomError({ 
                name: "LoginError", 
                status: 422, 
                code: "USR_01", 
                message: "unable to log in customer", 
                field: [errors]
            });

            return next(error);
        }

        try {
            const customerService = Container.get('customerService');
            const response = await customerService.login(req.body);
            return res.json(response);
        } catch (error) {
            return next(error);
        }
    });

    route.post('/customers/facebook', 
        validateFacebookLogin, 
        checkAccessTokenOrThrow, 
        passport.authenticate('facebook-token', {session: false}),
        async (req, res)  => {
            try {
                if(!req.user){
                    res.setStatus(401)
                    res.json({
                        name: "LoginError", 
                        status: 401, 
                        code: "USR_03", 
                        message: "unable to authenticate customer via facebook", 
                        field: 'access_token'
                    })
                }

                return res.json(req.user); 
            } catch (error) {
                return next(error);
            }  
        }
    );

    /**
     * GET Request
     */
    route.get('/customer', verifyToken, async (req, res, next) => {
        try {
            const customerId = req.decoded.id;
            const customerService = Container.get('customerService');
            const customer = await customerService.getCustomer(customerId);

            return res.json(customer);
        } catch (error) {
            return next(error);
        }
    });

    /**
     * PUT Request
     */
    route.put('/customer', validateUpdateCustomer, verifyToken, async (req, res, next) => {
        const errors = filterError(validationResult(req));
        
        if (errors) {
            const error = new CustomError({ 
                name: "LoginError", 
                status: 422, 
                code: "USR_04", 
                message: "unable customer update customer details", 
                field: [errors]
            });

            return next(error);
        }

        try {
            const customerId = req.decoded.id;
            const customerService = Container.get('customerService');
            const response = await customerService.update(req.body, customerId);
            return res.json(response);
        } catch (error) {
            return next(error);
        }
    });

    route.put('/customers/address', validateUpdateCustomerAddress, verifyToken, async (req, res, next) => {
        const errors = filterError(validationResult(req));
        
        if (errors) {
            const error = new CustomError({ 
                name: "LoginError", 
                status: 422, 
                code: "USR_05", 
                message: "unable customer update customer adress", 
                field: [errors]
            });

            return next(error);
        }

        try {
            const customerId = req.decoded.id;
            const customerService = Container.get('customerService');
            const response = await customerService.update(req.body, customerId);
            return res.json(response);
        } catch (error) {
            return next(error);
        }

    });

    route.put('/customers/creditCard', validateUpdateCustomerCreditCard, verifyToken, async (req, res, next) => {
        const errors = filterError(validationResult(req));
        
        if (errors) {
            const error = new CustomError({ 
                name: "LoginError", 
                status: 422, 
                code: "USR_06", 
                message: "unable customer update customer credit card", 
                field: [errors]
            });

            return next(error);
        }

        try {
            const customerId = req.decoded.id;
            const customerService = Container.get('customerService');
            const response = await customerService.update(req.body, customerId);
            return res.json(response);
        } catch (error) {
            return next(error);
        }
    });
}