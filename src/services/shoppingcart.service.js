'use strict';
const uuid = require('uuid/v4');
const { Container } =  require('typedi');
const { CustomError } = require('../utils/errorHelpers');

class ShoppingCartService {

    async addItemToShoppingcart(cartId, productId, attributes){
        try {
            const shoppingCartModel = Container.get('shoppingCartModel');
            let response = shoppingCartModel.addItemToCart(cartId,productId, attributes);
            response = await shoppingCartModel.getAllItemsInCart();
            return response;
        } catch (error) {
            throw error;
        }
    }

    async getItemsInShoppingcart(cartId){
        try {
            const shoppingCartModel = Container.get('shoppingCartModel');
            const response =  await shoppingCartModel.getItemsInCart(cartId);
            return response;
        } catch (error) {
            throw error;
        }
    }

    async updateItemInShoppingcart(itemId, quantity){
        try {
            const shoppingCartModel = Container.get('shoppingCartModel');
            await shoppingCartModel.updateItemInCart(itemId, quantity);
            const response = await shoppingCartModel.getAllItemsInCart();
            return response;
        } catch (error) {
            throw error;
        }
    }

    async emptyShoppingcart(cartId){
        try {
            const shoppingCartModel = Container.get('shoppingCartModel');
            const response = await shoppingCartModel.deleteAllItemsFromCart(cartId);
            return [];
        } catch (error) {
            throw error;
        }
    }

    async moveItemToShoppingcart(itemId){
        try {
            const shoppingCartModel = Container.get('shoppingCartModel');
            const response = await shoppingCartModel.moveItemToCart(itemId);
            return {};
        } catch (error) {
            throw error;
        }
    }

    async getTotalAmountInShoppingcart(cartId){
        try {
            const shoppingCartModel = Container.get('shoppingCartModel');
            const response = await shoppingCartModel.getItemsInCart(cartId);
            const total = response.reduce(((sum, val) => sum + val.sub_total),0);   
            
            return {
                total_amount: total
            }            
        } catch (error) {
            throw error;
        }
    }

    async moveItemsToSavedForLater(itemId){
        try {
            const shoppingCartModel = Container.get('shoppingCartModel');
            const response = await shoppingCartModel.addItemToSaveForLater(itemId);
            return {};            
        } catch (error) {
            throw error;
        }
    }

    async getItemsFromSavedForLater(cartId){
        try {
            const shoppingCartModel = Container.get('shoppingCartModel');
            const response = await shoppingCartModel.getItemsFromSaveForLater(cartId);
            return response;
        } catch (error) {
            throw error;
        }
    }

    async removeItemFromShoppingcart(itemId){
        try {
            const shoppingCartModel = Container.get('shoppingCartModel');
            const response = await shoppingCartModel.deleteItemFromCart(itemId);
            return {};         
        } catch (error) {
            throw error;
        }
    }

    /**
     * cache cart_id by ip address, this can be improved though
     * @param {object} request 
     */
    async generateShoppingcartId(ip){
        try {
            const cartId = uuid();
            return {
                cart_id: cartId.split('-')[0]
            };
        } catch (error) {
            throw error;
        }   
    }
}

module.exports = ShoppingCartService;