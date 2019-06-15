const { Container } =  require('typedi');
const orderEvents = Container.get('orderEvents');
const emailQueue = Container.get('emailQueue');

async function sendOrderCreationEmail(order) {
    try {
        const subject = 'Order has been created!';
        const body = `Hey ${order.name}, thanks for creating an order on our store. Your order id is ${order.orderId}.`;
        const jobId = await emailQueue.add('sendEmail', {
            email: order.email,
            subject: subject,
            body: body
        });
    } catch (error) {
        throw error;
    }
    
}
orderEvents.on('order_created', sendOrderCreationEmail)
module.exports = sendOrderCreationEmail;