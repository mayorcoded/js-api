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

describe('category services', () => {
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

    describe('get categories', () => {
        it('should get all product categories', async () => {
            const response = await request.get('/api/categories');
            expect(response.status).to.equal(200);
        });
    });

    describe('get category', () => {
        it('should return category if it exist', async () => {
            const response = await request.get('/api/categories/1');
            expect(response.status).to.equal(200);
        });
    });

    describe('get product category', () => {
        it('should return product category if it exist', async () => {
            const response = await request.get('/api/categories/inProduct/1');
            expect(response.status).to.equal(200);
        });
    });

    describe('get department category', () => {
        it('should return category department if it exist', async () => {
            const response = await request.get('/api/categories/inDepartment/1');
            expect(response.status).to.equal(200);
        });
    });
});