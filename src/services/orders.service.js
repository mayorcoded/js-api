'use strict';
const { Container } =  require('typedi');

class OrderService {
    async addOrder(cartId, shippingId, taxId, customerId){
        try {
            const shoppingcartModel = Container.get('shoppingCartModel');
            const cartItems = await shoppingcartModel.getItemsInCart(cartId);
            const totalAmount = cartItems.reduce(((sum, val) => sum + val.sub_total),0);

            const ordersModel = Container.get('OrdersModel');
            const orderResult = await ordersModel.insertOrder(totalAmount, customerId, shippingId, taxId);
            const orderId = orderResult.insertId;

            const orderDetails = []
            cartItems.forEach(item => {
                orderDetails.push([orderId, item.product_id, item.attributes, item.name, item.quantity, item.price]);
            });

            const result = await ordersModel.insertOrderDetails(orderDetails);

            const customerService = Container.get('customerService');
            const customer = await customerService.getCustomer(customerId);
            
            const orderEvents = Container.get('orderEvents');
            orderEvents.emit('order_created',{ email: customer.email, name: customer.name, orderId: orderId});

            return {
                orderId: orderId
            };
        } catch (error) {
            throw error;
        }
        
    }
    
    async getOrderDetails(orderId){
        try {
            const ordersModel = Container.get('OrdersModel');
            const result = await ordersModel.getOrderDetails(orderId);
            return result;
        } catch (error) {
            throw error;
        }
    }

    async getCustomerOrders(customerId){
        try {
            const ordersModel = Container.get('OrdersModel');
            const result = await ordersModel.getCustomerOrders(customerId);
            return result;
        } catch (error) {
            throw error;
        }
    }

    async getOrder(orderId){
        try {
            const ordersModel = Container.get('OrdersModel');
            const result = await ordersModel.getOrder(orderId);
            return result;
        } catch (error) {
            throw error;
        }
    }
}

module.exports = OrderService;