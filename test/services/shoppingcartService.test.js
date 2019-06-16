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

describe('order services', () => {
    let server;
    let request;
    let apiAccessToken;
    let orderId;
    let cartId;
    let itemId;
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
    
    describe('get cart id', () => {
        it('should return a cart id', async () => {
            const response = await request.get(`/api/shoppingcart/generateUniqueId`);
            expect(response.status).to.equal(200);
            cartId = response.body.cart_id;
        })
    });

    describe('add item to cart', () => {
        it('should add items to a cart', async () => {
            const cart = {
                cart_id: cartId,
                product_id: 1,
                attributes: 'some attributes of the product'
            }

            const response = await request.post(`/api/shoppingcart/add`).send(cart).set('Accept', 'application/json') ;
            expect(response.status).to.equal(200);
            itemId = response.body[0].item_id;
        })
    });

    describe('get cart items', () => {
        it('should return a cart info', async () => {
            const response = await request.get(`/api/shoppingcart/${cartId}`);
            expect(response.status).to.equal(200);
        })
    });

    describe('update cart item', () => {
        it('should update the items in cart', async () => {
            const update = {
                quantity: 34
            }

            const response = await request.put(`/api/shoppingcart/update/${itemId}`).send(update).set('Accept', 'application/json') ;
            expect(response.status).to.equal(200);
        })
    });

    describe('empty cart', () => {
        it('should delete all items from cart', async () => {
            const response = await request.delete(`/api/shoppingcart/empty/${cartId}`);
            expect(response.status).to.equal(200);
        })
    });

    describe('move item to cart', () => {
        it('should return an item to cart', async () => {
            const response = await request.get(`/api/shoppingcart/moveToCart/${itemId}`);
            expect(response.status).to.equal(200);
        })
    });

    describe('total amount in cart', () => {
        it('should return the total amount in a cart', async () => {
            const response = await request.get(`/api/shoppingcart/totalAmount/${cartId}`);
            expect(response.status).to.equal(200);
        })
    });

    describe('move item to saveforlater', () => {
        it('should remove item from cart and add to saveforlater', async () => {
            const response = await request.get(`/api/shoppingcart/saveForLater/${itemId}`);
            expect(response.status).to.equal(200);
        })
    });

    describe('get saveforlater items', () => {
        it('should return all saveforlater items', async () => {
            const response = await request.get(`/api/shoppingcart/getSaved/${cartId}`);
            expect(response.status).to.equal(200);
        })
    });

    describe('remove item from cart', () => {
        it('should remove an item from cart', async () => {
            const response = await request.delete(`/api/shoppingcart/removeProduct/${itemId}`);
            expect(response.status).to.equal(200);
        })
    });
});