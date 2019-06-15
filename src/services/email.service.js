'use strict';
const sendgrid = require('@sendgrid/mail');
const config = require('../config');

class EmailService {

    constructor(){
        sendgrid.setApiKey(config.sendgrid.api_key);
    }

    async sendEmail(email, subject, body){
        try {
            const message = {
                to: email,
                from: 'mayor@turing.com',
                subject: subject,
                text: body,
            }
    
            const response = await sendgrid.send(message);
            return response;
        } catch (error) {
            throw error;
        }
    }
}


module.exports = EmailService;