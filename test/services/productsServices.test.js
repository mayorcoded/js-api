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

describe('product service', () => {
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

    describe('get all products', () => {
        it('should return all products', async () => {
            const response = await request.get('/api/products');
            expect(response.status).to.equal(200);
        });
    });

    describe('search products', () => {
        it('should return results for product if exists', async () => {
            const response = await request.get('/api/products/search').query({search_string: 'arc'});
            expect(response.status).to.equal(200);
        });
    });

    //TODO:expect body not to be empty if product exist, and body to be
    //empty if product exist
    describe('get product by product_id', () => {
        it('should return product with product_id if it exists', async () => {
            const response = await request.get('/api/products/2');
            expect(response.status).to.equal(200);
        });
    });

    //if products in a cat dont exist, then body should be empty
    describe('get products in a certain category', () => {
        it('should return all products in a category if they exist', async () => {
            const response = await request.get('/products/inCategory/9');
            expect(response.status).to.equal(200);
        });
    });

    describe('get products in a department', () => {
        it('should return all produts in a department if they exist', async () => {
            const response = await request.get('/products/inDepartment/9');
            expect(response.status).to.equal(200);
        });
    });

    describe('get product details', () => {
        it('should return the details of a product if it exists', async () => {
            const response = await request.get('/products/2/details');
            expect(response.status).to.equal(200);            
        })
    })

    describe('get product locations', () => {
        it('should return the locations of a product if it exists', async () => {
            const response = await request.get('/products/2/locations');
            expect(response.status).to.equal(200);            
        })
    })

    describe('get product reviews', () => {
        it('should return the reviews of a product if it exists', async () => {
            const response = await request.get('/products/2/locations');
            expect(response.status).to.equal(200);            
        })
    })

    describe('save product reviews', () => {
        it('should save product review for a product', async () => {
            const review = {
                review: 'yadayad ayayada'
            }
            const response = await request.post('/products/2/reviews').send(review).set('USER-KEY', apiAccessToken).set('Accept', 'application/json');
            expect(response.status).to.equal(200);
        })
    })
});