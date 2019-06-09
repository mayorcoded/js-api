'use strict';
const { Router } = require('express');
const { Container } =  require('typedi');

const route = Router()

module.exports = async(app) => {
    app.use(route);
    
    route.get('/tax', async (req, res, next) => {
        try {
            const taxService = Container.get('taxService');
            const response = await taxService.getAllTaxes();
            return res.json(response);
        } catch (error) {
            return next(error);
        }
    });

    route.get('/tax/:tax_id([0-9]+)', async (req, res, next) => {
        try {
            const {tax_id} = req.params;
            const taxService = Container.get('taxService');
            const response = await taxService.getTax(tax_id)
            return res.json(response);
        } catch (error) {
            return next(error);
        }
    });
}