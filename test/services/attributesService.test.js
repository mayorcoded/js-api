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

describe('attribute service', () => {
    let server;
    let request;
    let apiAccessToken;
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

    describe('get attributes', () => {
        it('should get all product attributes', async () => {
            const response = await request.get('/api/attributes');
            expect(response.status).to.equal(200);
        });
    });

    describe('get attribute', () => {
        it('should return attribute if it exist', async () => {
            const response = await request.get('/api/attributes/1');
            expect(response.status).to.equal(200);
        });
    });

    describe('get attribute value', () => {
        it('should return the values of an attribute if it exist', async () => {
            const response = await request.get('/api/attributes/values/1');
            expect(response.status).to.equal(200);
        });
    });

    describe('get product attribute', () => {
        it('should return the values of an attribute if it exist', async () => {
            const response = await request.get('/api/attributes/inProduct/1');
            expect(response.status).to.equal(200);
        });
    });
});