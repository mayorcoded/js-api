'use strict';

const { Router } = require('express');
const { validateQueryString, validateProductReview} = require('../../utils/validators');
const { filterError, CustomError} = require('../../utils/errorHelpers')
const { validationResult } = require("express-validator/check");
const { Container } =  require('typedi');
const { verifyToken } = require('../../api/middlewares');

const cache = require('../../utils/cache');
const route = Router();

module.exports = async(app) => {
    app.use(route);

    route.get('/products', cache,  async (req, res, next) => { 
        try {
            const productService = Container.get('productService');
            const response = await productService.getProducts(req.query);
            return res.json(response);
        } catch (error) {
            return next(error);
        }
    });

    route.get('/products/search', validateQueryString ,cache, async (req, res, next) => { 
        const errors = filterError(validationResult(req));

        if (errors) {
            const error = new CustomError({ 
                name: "ProductsError", 
                status: 422, 
                code: "PDR_00", 
                message: "unable to fetch product", 
                field: [errors]
            });

            return next(error);
        }

        try {
            const productService = Container.get('productService');
            const response = await productService.searchProducts(req.query);
            return res.json(response);
        } catch (error) {
            return next(error);
        }
    });

    route.get('/products/:product_id([0-9]+)', cache, async (req, res, next) => { 
        try {
            const productService = Container.get('productService');
            const response = await productService.getProduct(req.params);
            return res.json(response);
        } catch (error) {
            return next(error);
        }
    });

    route.get('/products/inCategory/:category_id([0-9]+)', cache, async (req, res, next) => { 
        try {
            const productService = Container.get('productService');
            const response = await productService.getProductCategory(req);
            return res.json(response);
        } catch (error) {
            return next(error);
        }
    });

    route.get('/products/inDepartment/:department_id([0-9]+)', cache, async (req, res, next) => { 
        try {
            const productService = Container.get('productService');
            const response = await productService.getProductDepartments(req);
            return res.json(response);
        } catch (error) {
            return next(error);
        }
    });

    route.get('/products/:product_id([0-9]+)/details', cache, async (req, res, next) => { 
        try {
            const productService = Container.get('productService');
            const response = await productService.getProductDetails(req.params);
            return res.json(response);
        } catch (error) {
            return next(error);
        }
    });

    route.get('/products/:product_id([0-9]+)/locations', cache, async (req, res, next) => { 
        try {
            const productService = Container.get('productService');
            const response = await productService.getProductLocations(req.params);
            return res.json(response);
        } catch (error) {
            return next(error);
        }
    });

    route.get('/products/:product_id([0-9]+)/reviews', cache, async (req, res, next) => { 
        try {
            const productService = Container.get('productService');
            const response = await productService.getProductReviews(req.params);
            return res.json(response);
        } catch (error) {
            return next(error);
        }
    });

    route.post('/products/:product_id([0-9]+)/reviews', verifyToken, validateProductReview, cache, async (req, res, next) => { 
        try {
            req.body.customer_id = req.decoded.id
            const productService = Container.get('productService');
            const response = await productService.addProductReview(req);
            return res.json();
        } catch (error) {
            return next(error);
        }
    });
}