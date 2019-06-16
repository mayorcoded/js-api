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

describe('shipping services', () => {
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

    describe('get shipping regions', () => {
        it('should return all shipping regions', async () =>{
            const response = await request.get(`/api/shipping/regions`);
            expect(response.status).to.equal(200);
        })
    });

    describe('get shipping regions info', () => {
        it('should return shipping region info if it exits', async () =>{
            const response = await request.get(`/api/shipping/regions/${1}`);
            expect(response.status).to.equal(200);
        })
    });
});