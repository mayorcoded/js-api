'use strict';
const { Container } =  require('typedi');
const { CustomError } = require('../utils/errorHelpers');

class ShoppingCartModel {

    async addItemToCart(cart_id, product_id, attributes){
        try {
            const sql = Container.get('mysql'); 
            const buyNow = 1;
            const quantity = 1;
            const params = [cart_id, product_id, attributes, quantity, buyNow];
            const row = await sql.query(`INSERT INTO shopping_cart 
                                    (cart_id, product_id, attributes, quantity, buy_now, added_on) 
                                    VALUES (?, ?, ?, ?, ?, localtimestamp())`, params);
            return row;
        } catch (error) {
            throw new CustomError({
                name: "ShoppingCartModelError", 
                status: 400, 
                code: "SCMDLR_OO", 
                message: error.message, 
                field: ['cart_id', 'product_id', 'attribute']
            });
        }
    }
    
    async getItemsInCart(cart_id){
        try {
            const sql = Container.get('mysql'); 
            const row = await sql.query(`SELECT sc.item_id, 
                                        p.name, 
                                        sc.attributes, 
                                        sc.product_id, 
                                        p.price,
                                        sc.quantity,
                                        p.image,
                                    (p.price * sc.quantity) as sub_total
                                    FROM shopping_cart as sc
                                    JOIN product as p
                                    ON (sc.product_id = p.product_id)
                                    WHERE cart_id = ? 
                                    AND buy_now = 1`, [cart_id]);
            return row;
        } catch (error) {
            throw new CustomError({
                name: "ShoppingCartModelError", 
                status: 400, 
                code: "SCMDLR_O1", 
                message: error.message, 
                field: ['cart_id']
            });
        }
    }

    async updateItemInCart(item_id, quantity){
        try {
            const sql = Container.get('mysql'); 
            const row = await sql.query(`UPDATE shopping_cart
                                  SET quantity = ?
                                  WHERE item_id = ? 
                                  AND buy_now = 1`, [quantity, item_id]);
            return row;
        } catch (error) {
            throw new CustomError({
                name: "ShoppingCartModelError", 
                status: 400, 
                code: "SCMDLR_O2", 
                message: error.message, 
                field: ['item_id', 'quantity']
            });
        }
    }

    async deleteAllItemsFromCart(cart_id){
        try {
            const sql = Container.get('mysql'); 
            const row = await sql.query(`DELETE FROM shopping_cart WHERE cart_id = ?`, [cart_id]);
            return row;
        } catch (error) {
            throw new CustomError({
                name: "ShoppingCartModelError", 
                status: 400, 
                code: "SCMDLR_O3", 
                message: error.message, 
                field: ['cart_id']
            });
        }
    }

    async deleteItemFromCart(item_id){
        try {
            const sql = Container.get('mysql'); 
            const row = await sql.query(`DELETE FROM shopping_cart WHERE item_id = ?`, [item_id]);
            return row;
        } catch (error) {
            throw new CustomError({
                name: "ShoppingCartModelError", 
                status: 400, 
                code: "SCMDLR_O4", 
                message: error.message, 
                field: ['item_id']
            });
        }
    }

    async moveItemToCart(item_id){
        try {
            const sql = Container.get('mysql'); 
            const row = await sql.query(`UPDATE shopping_cart
                                    SET buy_now = 1
                                    WHERE item_id = ?`, [item_id]);
            return row;
        } catch (error) {
            throw new CustomError({
                name: "ShoppingCartModelError", 
                status: 400, 
                code: "SCMDLR_O5", 
                message: error.message, 
                field: ['item_id']
            });
        }
    }

    async addItemToSaveForLater(item_id){
        try {
            const sql = Container.get('mysql'); 
            const row = await sql.query(`UPDATE shopping_cart
                                    SET buy_now = 0
                                    WHERE item_id = ?`, [item_id]);
            return row;
        } catch (error) {
            throw new CustomError({
                name: "ShoppingCartModelError", 
                status: 400, 
                code: "SCMDLR_O6", 
                message: error.message, 
                field: ['item_id']
            });
        }
    }

    async getItemsFromSaveForLater(cart_id){
        try {
            const sql = Container.get('mysql'); 
            const row = await sql.query(`SELECT sc.item_id, 
                                        p.name, 
                                        sc.attributes, 
                                        sc.product_id, 
                                        p.price,
                                        sc.quantity,
                                        p.image,
                                    (p.price * sc.quantity) as sub_total
                                    FROM shopping_cart as sc
                                    JOIN product as p
                                    ON (sc.product_id = p.product_id)
                                    WHERE cart_id = ? 
                                    AND buy_now = 0`, [cart_id]);
            return row;
        } catch (error) {
            throw new CustomError({
                name: "ShoppingCartModelError", 
                status: 400, 
                code: "SCMDLR_O7", 
                message: error.message, 
                field: ['cart_id']
            });
        }
    }


    async getAllItemsInCart(){
        try {
            const sql = Container.get('mysql'); 
            const row = await sql.query(`SELECT sc.item_id, 
                                        p.name, 
                                        sc.attributes, 
                                        sc.product_id, 
                                        p.price,
                                        sc.quantity,
                                        p.image,
                                    (p.price * sc.quantity) as sub_total
                                    FROM shopping_cart as sc
                                    JOIN product as p
                                    ON (sc.product_id = p.product_id)
                                    WHERE buy_now = 1 `);
            return row;
        } catch (error) {
            throw new CustomError({
                name: "ShoppingCartModelError", 
                status: 400, 
                code: "SCMDLR_O8", 
                message: error.message, 
                field: ['cart_id']
            });
        }
    }
}

Container.set('shoppingCartModel', new ShoppingCartModel())
module.exports = ShoppingCartModel;