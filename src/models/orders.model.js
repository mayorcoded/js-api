'use strict';
const { Container } =  require('typedi');
const { CustomError } = require('../utils/errorHelpers');

class OrdersModel{

    async insertOrder(totalAmount, customerId, shippingId, taxId ){
        try {
            const sql = Container.get('mysql'); 
            const row = sql.query(` INSERT INTO orders 
                                        (total_amount, created_on, customer_id, shipping_id, tax_id)
                                    VALUES (?, localtimestamp(), ?,?,?)`, 
                                    [totalAmount, customerId, shippingId, taxId]);
            return row;
        } catch (error) {
            throw new CustomError({
                name: "OrdersModelError", 
                status: 400, 
                code: "ORDMDLR_OO", 
                message: error.message, 
                field: ['cart_id', 'shipping_id', 'tax_id']
            });
        }
    }

    async insertOrderDetails(orderDetails){
        try {
            const sql = Container.get('mysql'); 
            const row = sql.query(`INSERT INTO order_detail 
                                        (order_id, product_id, attributes, product_name, quantity, unit_cost)
                                    VALUES ?`, [orderDetails]);
            return row;
        } catch (error) {
            throw new CustomError({
                name: "OrdersModelError", 
                status: 400, 
                code: "ORDMDLR_O1", 
                message: error.message, 
                field: ['orderDetails']
            });
        }
    }

    async getOrderDetails(order_id){
        try {
            const sql = Container.get('mysql'); 
            const row = sql.query(`SELECT * FROM order_detail WHERE order_id = ?`, [order_id]);
            return row;
        } catch (error) {
            throw new CustomError({
                name: "OrdersModelError", 
                status: 400, 
                code: "ORDMDLR_O2", 
                message: error.message, 
                field: ['order_id']
            });
        }
    }

    async getCustomerOrders(customer_id){
        try {
            const sql = Container.get('mysql'); 
            const row = sql.query(`SELECT * FROM orders WHERE customer_id = ?`, [customer_id]);
            return row;
        } catch (error) {
            throw new CustomError({
                name: "OrdersModelError", 
                status: 400, 
                code: "ORDMDLR_O3", 
                message: error.message, 
                field: ['customer_id']
            });
        }
    }

    async getOrder(order_id){
        try {
            const sql = Container.get('mysql'); 
            const row = sql.query(`SELECT orders.order_id, 
                                          orders.total_amount, 
                                          orders.created_on, 
                                          orders.shipped_on, 
                                          orders.status, 
                                          order_detail.product_name
                                    FROM orders 
                                    JOIN order_detail
                                    ON( orders.order_id = order_detail.order_id)
                                    WHERE orders.order_id = ?`, [order_id]);
            return row;
        } catch (error) {
            throw new CustomError({
                name: "OrdersModelError", 
                status: 400, 
                code: "ORDMDLR_O2", 
                message: error.message, 
                field: ['order_id']
            });
        }
    }
}

Container.set('OrdersModel', new OrdersModel())
module.exports = OrdersModel;