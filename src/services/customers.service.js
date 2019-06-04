'use strict';
const bcrypt = require('bcryptjs');
const { Container } =  require('typedi');
const { CustomError } = require('../utils/errorHelpers');
const { createToken } = require('../utils/jwt');
const maskCreditCardNumber = Symbol('maskCreditCardNumber');

class CustomerService {

    async register(data){
        try {
            const customerModel = Container.get('customerModel');
            let customer = await customerModel.getCustomer('email',data.email);

            if(customer.length > 0){
                throw new CustomError({
                    name: "RegistrationError",
                    status: 400,
                    code: "AUT_00",
                    message: "a customer with this email already exist",
                    field: "email"
                });
            }

            const hashedPassword = await bcrypt.hash(data.password, 8);
            data.password = hashedPassword
            await customerModel.addCustomerToDb(data);

            customer = await customerModel.getCustomer('email', data.email);
            const token = createToken({ id: customer[0].customer_id, email: customer[0].email });

            const response = {
                customer: {
                    schema: customer[0]
                },
                accessToken: token,
                expires_in: '24h'
            }

            return response;
        } catch (error) {
            throw error;
        }
    }

    async login(data) {
        try {
            const customerModel = Container.get('customerModel');
            const customer = await customerModel.getCustomer('email', data.email);

            if(customer.length < 1){
                throw new CustomError({
                    name: "LoginError",
                    status: 400,
                    code: "AUT_01",
                    message: "invalid customer credentials",
                    field: ["email", "password"]
                });
            }

            const passwordIsValid = await bcrypt.compare(data.password, customer[0].password);
            if(!passwordIsValid){
                throw new CustomError({
                    name: "LoginError",
                    status: 400,
                    code: "AUTH_01",
                    message: "invalid customer credentials",
                    field: ["email", "password"]
                });
            }

            delete customer[0].password;
            const token = createToken({ id: customer[0].customer_id, email: customer[0].email });
            const response = {
                customer: {
                    schema: customer[0]
                },
                accessToken: token,
                expires_in: '24h'
            }

            return response;
        } catch (error) {
            throw error;
        }
    }

    async update(data, customerId){
        try {
            const customerModel = Container.get('customerModel');
            let customer = await customerModel.updateCustomer(data, customerId);
            customer = await customerModel.getCustomer('customer_id', customerId);
            delete customer[0].password;
            customer[0].credit_card = this[maskCreditCardNumber](customer[0].credit_card);

            return customer[0];
        } catch (error) {
            throw error;
        }
    }

    async loginCustomerViaFacebook(data){
        try {
            const response = {
                customer: {
                    schema: ""
                },
                accessToken: "",
                expires_in: '24h'
            }
            const customerModel = Container.get('customerModel');
            let customer = await customerModel.getCustomer('email', data.email);

            if(customer.length > 0){
                const token = createToken({ id: customer[0].customer_id, email: customer[0].email });
                response.customer.schema = customer[0];
                response.accessToken = token;
                return response;
            }

            await customerModel.addCustomerToDb(data);
            customer = await customerModel.getCustomer('email', data.email);
            delete customer[0].password;
            customer[0].credit_card = this[maskCreditCardNumber](customer[0].credit_card);

            const token = createToken({ id: customer[0].customer_id, email: customer[0].email });
            response.customer.schema = customer[0];
            response.accessToken = token;

            return response;
        } catch (error) {
            throw error;
        }
    }

    async getCustomer(customerId){
        try {
            const customerModel = Container.get('customerModel');
            let customer = await customerModel.getCustomer('customer_id', customerId);
            delete customer[0].password;
            customer[0].credit_card = this[maskCreditCardNumber](customer[0].credit_card);

            return customer[0];
        } catch (error) {
            throw error;
        }
    }

    [maskCreditCardNumber](creditCardNumber){
        return (creditCardNumber.length <= 4)? creditCardNumber: creditCardNumber.slice(0, -4).replace(/./g, 'X') + creditCardNumber.slice(-4);
    }
}

module.exports = CustomerService;
