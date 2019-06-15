const { Container } =  require('typedi');
const paymentEvents = Container.get('paymentEvents');
const emailQueue = Container.get('emailQueue');

async function sendPaymentConfirmationEmail(payment) {
    try {
        const subject = 'Payment Confirmed!';
        const body = `Hey ${payment.name}, thanks for making your payments. You paid $${payment.paymentInfo.amount} for the order ${payment.paymentInfo.orderId}`;

        const jobId = await emailQueue.add('sendEmail', {
            email: payment.email,
            subject: subject,
            body: body
        });
    } catch (error) {
        throw error;
    }
    
}
paymentEvents.on('payment_completed', sendPaymentConfirmationEmail);
module.exports = sendPaymentConfirmationEmail;