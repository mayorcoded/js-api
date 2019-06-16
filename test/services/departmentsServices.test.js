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

describe('department services', () => {
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

    describe('get all departments', () => {
        it('should get all departments', async () => {
            const response = await request.get('/api/departments');
            expect(response.status).to.equal(200);
        });
    })

    describe('get one department', () => {
        it('should get a department if it exists', async () => {
            const response = await request.get('/api/departments/1');
            expect(response.status).to.equal(200);
        });
    })
});