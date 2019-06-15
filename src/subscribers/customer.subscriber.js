const { Container } =  require('typedi');
const customerEvents = Container.get('customerEvents');
const emailQueue = Container.get('emailQueue');

async function sendWelcomeEmail(customer) {
    try {
        const subject = 'Welcome to my Ecommerce API!';
        const body = `Hey ${customer.name}, welcome to our ecommerce api. Our APIs have 99.99% uptime, 
                    so you never have to worry about downtimes. You get a free 100,000 API calls in your first month of signing up.
                    Our services are also very scalable, in fact, we can serve the world hahahah. Enjoyyyy!`;

        const jobId = await emailQueue.add('sendEmail', {
            email: customer.email,
            subject: subject,
            body: body
        });
    } catch (error) {
        throw error;
    }
    
}
customerEvents.on('customer_register', sendWelcomeEmail)
module.exports = sendWelcomeEmail;