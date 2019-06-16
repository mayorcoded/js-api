'use strict';

const Chance = require('chance');
const express = require('express');
const { expect } = require('chai');

const app = express();
const http = require('http');
const supertest = require('supertest');
const loaders = require('../../src/loaders');
const config = require('../../src/config');
loaders(app);
K
describe('customer service', () => {
    let server;
    let request;
    let apiAccessToken;
    const chance = new Chance();
    const email = chance.email({domain: "test.com"});
    const name = chance.name();
    const password = "123ABC";
    const facebookAccessToken = config.facebook.access_token

    beforeAll((done) => {
        server = http.createServer(app);
        server.listen(done);
        request = supertest(server);
    });

    afterAll((done) => {
        server.close(done);
    });

    describe('register customer', () => {

        it('should register a new customer', async () => {
            const customer = {
                email: email,
                name: name,
                password: password
            }

            const response = await request.post('/api/customers').send(customer).set('Accept', 'application/json')
            expect(response.status).to.equal(200);
            expect(response.body.customer).to.exist
            expect(response.body.customer.schema).to.exist
            expect(response.body.accessToken).to.exist
            expect(response.body.expires_in).to.exist
        });

        it('should not register a customer with an already existing email', async () => {
            const customer = {
                email: email,
                name: name,
                password: password
            }

            const response = await request.post('/api/customers').send(customer).set('Accept', 'application/json')
            expect(response.status).to.equal(400);
        });

        it('should not register a customer with missing pasword in request body', async () => {
            const customer = {
                email: email,
                name: name,
            }

            const response = await request.post('/api/customers').send(customer).set('Accept', 'application/json')
            expect(response.status).to.equal(422);
            expect(response.body.error).to.not.be.null;
            expect(response.body.error.message).to.equal('unable to register customer');
            expect(response.body.error.field.password).to.not.be.null;
        });

        it('should not register a customer with missing name in request body', async () => {
            const customer = {
                email: email,
                password: password
            }

            const response = await request.post('/api/customers').send(customer).set('Accept', 'application/json')
            expect(response.status).to.equal(422);
            expect(response.body.error).to.not.be.null;
            expect(response.body.error.message).to.equal('unable to register customer');
            expect(response.body.error.field.name).to.not.be.null;
        });

        it('should not register a customer with missing email in request body', async () => {
            const customer = {
                name: name,
                password: password
            }

            const response = await request.post('/api/customers').send(customer).set('Accept', 'application/json')
            expect(response.status).to.equal(422);
            expect(response.body.error).to.not.be.null;
            expect(response.body.error.message).to.equal('unable to register customer');
            expect(response.body.error.field.email).to.not.be.null;
        });

        it('should not register a customer with empty request body', async () => {
            const customer = {

            }

            const response = await request.post('/api/customers').send(customer).set('Accept', 'application/json')
            expect(response.status).to.equal(422);
            expect(response.body.error).to.not.be.null;
            expect(response.body.error.message).to.equal('unable to register customer');
            expect(response.body.error.field.email).to.not.be.null;
            expect(response.body.error.field.name).to.not.be.null;
            expect(response.body.error.field.password).to.not.be.null;
        });
    });

    describe('login cutomer', () => {

        it('should login existing customer', async () => {
            const customer = {
                email: email,
                password: password
            }

            const response = await request.post('/api/customers/login').send(customer).set('Accept', 'application/json');
            expect(response.status).to.equal(200);
            expect(response.body.customer).to.not.be.null;
            expect(response.body.customer.schema).to.not.be.null;
            expect(response.body.accessToken).to.not.be.null;
            expect(response.body.expires_in).to.not.be.null;
            apiAccessToken = response.body.accessToken;
        })


        it('should not login non-existing customer', async () => {
            const customer = {
                email: 'yada@email.com',
                password: password
            }

            const response = await request.post('/api/customers/login').send(customer).set('Accept', 'application/json');
            expect(response.status).to.equal(400);
            expect(response.body.error.message).to.equal('invalid customer credentials');
            expect(response.body.error.field).to.not.be.null;
        })

        it('should not login customer with missing email in request body', async () => {
            const customer = {
                password: password
            }

            const response = await request.post('/api/customers/login').send(customer).set('Accept', 'application/json');
            expect(response.status).to.equal(422);
            expect(response.body.error.message).to.equal('unable to log in customer');
            expect(response.body.error.field).to.not.be.null;
            expect(response.body.error.field.email).to.not.be.null;
        })

        it('should not login customer with missing password in request body', async () => {
            const customer = {
                email: email
            }

            const response = await request.post('/api/customers/login').send(customer).set('Accept', 'application/json');
            expect(response.status).to.equal(422);
            expect(response.body.error.message).to.equal('unable to log in customer');
            expect(response.body.error.field).to.not.be.null;
            expect(response.body.error.field.password).to.not.be.null;
        })

        it('should not login customer with missing request body', async () => {
            const customer = {

            }

            const response = await request.post('/api/customers/login').send(customer).set('Accept', 'application/json');
            expect(response.status).to.equal(422);
            expect(response.body.error.message).to.equal('unable to log in customer');
            expect(response.body.error.field).to.not.be.null;
        })

        it('should login customer via facebook', async () => {
            jest.setTimeout(30000);

            const accessToken = {
                access_token: facebookAccessToken
            }

            const response = await request.post('/api/customers/facebook').send(accessToken).set('Accept', 'application/json');
            expect(response.status).to.equal(200);
            expect(response.body.customer).to.not.be.null;
            expect(response.body.customer.schema).to.not.be.null;
            expect(response.body.accessToken).to.not.be.null;
            expect(response.body.expires_in).to.not.be.null;
        })

        it('should not login customer with missing access_token via facebook', async () => {
            const accessToken = {

            }

            const response = await request.post('/api/customers/facebook').send(accessToken).set('Accept', 'application/json');
            expect(response.status).to.equal(422);
            expect(response.body.error.message).to.equal('unable to login with facebook');
            expect(response.body.error.field).to.not.be.null;
        })
    })

    describe('get customer', () => {
        it('should return customer details', async () => {

            const response = await request.get('/api/customer').set('USER-KEY', apiAccessToken);
            expect(response.status).to.equal(200);
            expect(response.body).to.not.be.empty;
        })

        it('should not return customer details if USER-KEY is not in request header', async () => {
            const response = await request.get('/api/customer');
            expect(response.status).to.equal(403);
            expect(response.body.error).to.not.be.empty;
            expect(response.body.error.message).to.equal('Unauthorized Access, undefined header. Please log in.');
        })
    })

    describe('update customer', () => {
        it('should not update customer details with missing USER-KEY header in request', async () => {
            const customerUpdate = {
                email: email,
                name: 'some updated name'
            }

            const response = await  request.put('/api/customer').send(customerUpdate).set('Accept', 'application/json')
            expect(response.status).to.equal(403);
            expect(response.body.error.message).to.equal('Unauthorized Access, undefined header. Please log in.');
        })

        it('should update customer details', async () => {
            const customerUpdate = {
                email: email,
                name: 'some updated name'
            }

            const response = await  request.put('/api/customer').send(customerUpdate).set('USER-KEY', apiAccessToken).set('Accept', 'application/json');
            expect(response.status).to.equal(200);
            expect(response.body).to.not.be.empty;
        })

        it('should update customer credit card', async () => {
            const customerUpdate = {
                credit_card: 3434131315
            }

            const response = await  request.put('/api/customers/creditCard').send(customerUpdate).set('USER-KEY', apiAccessToken).set('Accept', 'application/json')
            expect(response.status).to.equal(200);
            expect(response.body).to.not.be.empty;
        })

        it('should update customer address', async () => {
            const customerUpdate = {
                credit_card: 3434131315
            }

            const response = await  request.put('/api/customers/creditCard').send(customerUpdate).set('USER-KEY', apiAccessToken).set('Accept', 'application/json')
            expect(response.status).to.equal(200);
            expect(response.body).to.not.be.empty;
        })
    })
});
