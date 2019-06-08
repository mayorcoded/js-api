'use strict';

const { Router } = require('express');
const { validateNewItem, validateUpdateCartItem} = require('../../utils/validators');
const { filterError, CustomError} = require('../../utils/errorHelpers')
const { validationResult } = require("express-validator/check");
const { Container } =  require('typedi');

const route = Router();

module.exports = async(app) => {
    app.use(route);

    route.get('/shoppingcart/generateUniqueId', async(req, res, next) => {
        try {
            const shoppingcartService = Container.get('shoppingcartService');
            const response = await shoppingcartService.generateShoppingcartId(req.ip);
            return res.json(response);
        } catch (error) {
            return next(error);
        }
    });

    route.post('/shoppingcart/add', validateNewItem, async(req, res, next) => {
        const errors = filterError(validationResult(req));

        if (errors) {
            const error = new CustomError({ 
                name: "ShoppingCartError", 
                status: 422, 
                code: "SHPER_00", 
                message: "failed to add shopping item to shopping cart", 
                field: [errors]
            });

            return next(error);
        }

        try {
            const {cart_id, product_id, attributes} = req.body;
            const shoppingcartService = Container.get('shoppingcartService');
            const response = await shoppingcartService.addItemToShoppingcart(cart_id, product_id, attributes);
            return res.json(response);
        } catch (error) {
            return next(error); 
        }
    });

    route.get('/shoppingcart/:cart_id', async(req, res, next) => {
        try {
            const {cart_id} = req.params;
            const shoppingcartService = Container.get('shoppingcartService');
            const response = await shoppingcartService.getItemsInShoppingcart(cart_id);
            return res.json(response);
        } catch (error) {
            return next(error);
        }
    });

    route.put('/shoppingcart/update/:item_id([0-9]+)', validateUpdateCartItem, async(req, res, next) => {
        const errors = filterError(validationResult(req));

        if (errors) {
            const error = new CustomError({ 
                name: "ShoppingCartError", 
                status: 422, 
                code: "SHPER_00", 
                message: "failed to add shopping item to shopping cart", 
                field: [errors]
            });

            return next(error);
        }

        try {
            const {item_id} = req.params;
            const {quantity} = req.body;
            const shoppingcartService = Container.get('shoppingcartService');
            const response = await shoppingcartService.updateItemInShoppingcart(item_id,quantity);  
            return res.json(response);    
        } catch (error) {
            return next(error);
        }
    });

    route.delete('/shoppingcart/empty/:cart_id', async(req, res, next) => {
        try {
            const {cart_id} = req.params;
            const shoppingcartService = Container.get('shoppingcartService');
            const response = await shoppingcartService.emptyShoppingcart(cart_id);
            return res.json(response);
        } catch (error) {
            return next(error);
        }
    });

    route.get('/shoppingcart/moveToCart/:item_id([0-9]+)', async(req, res, next) => {
        try {
            const {item_id} = req.params;
            const shoppingcartService = Container.get('shoppingcartService');
            const response = await shoppingcartService.moveItemToShoppingcart(item_id);
            return res.json(response);
        } catch (error) {
            return next(error);
        }
    });

    route.get('/shoppingcart/totalAmount/:cart_id', async (req, res, next) => {
        try {
            const {cart_id} = req.params;
            const shoppingcartService = Container.get('shoppingcartService');
            const response = await shoppingcartService.getTotalAmountInShoppingcart(cart_id);
            return res.json(response);
        } catch (error) {
            return next(error);
        }
    });

    route.get('/shoppingcart/saveForLater/:item_id([0-9]+)', async (req, res, next) => {
        try {
            const {item_id} = req.params;
            const shoppingcartService = Container.get('shoppingcartService');
            const response = await shoppingcartService.moveItemsToSavedForLater(item_id);
            return res.json(response);
        } catch (error) {
            return next(error);
        }
    });

    route.get('/shoppingcart/getSaved/:cart_id', async (req, res, next) => {
        try {
            const {cart_id} = req.params;
            const shoppingcartService = Container.get('shoppingcartService');
            const response = await shoppingcartService.getItemsFromSavedForLater(cart_id);
            return res.json(response);
        } catch (error) {
            return next(error);            
        }
    });

    route.delete('/shoppingcart/removeProduct/:item_id([0-9]+)', async (req, res, next) => {
        try {
            const {item_id} = req.params;
            const shoppingcartService = Container.get('shoppingcartService');
            const response = await shoppingcartService.removeItemFromShoppingcart(item_id);
            return res.json(response);
        } catch (error) {   
            return next(error);
        }
    });
}
