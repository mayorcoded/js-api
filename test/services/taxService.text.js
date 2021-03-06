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

describe('tax services', () => {
    let server;
    let request;
    let apiAccessToken;
    let orderId;
    const chance = new Chance();
    const email = chance.email({domain: "test.com"}); 
    const name = chance.name();
    const password = "123ABC";

    beforeAll((done) => {
        server = http.createServer(app);
        server.listen(done);
        request = supertest(server);
    });
    
    afterAll((done) => {
        server.close(done);
    });

    describe('get all tax', () => {
        it('should return all taxes', async () =>{
            const response = await request.get(`/api/tax`);
            expect(response.status).to.equal(200);
        })
    });

    describe('get tax', () => {
        it('should return tax if it exits', async () =>{
            const response = await request.get(`/api/tax/1`);
            expect(response.status).to.equal(200);
        })
    });
});