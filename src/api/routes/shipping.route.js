'use strict';
const { Router } = require('express');
const { Container } =  require('typedi');

const route = Router()

module.exports = async(app) => {
    app.use(route);
    
    route.get('/shipping/regions', async (req, res, next) => {
        try {
            const shippingService = Container.get('shippingService');
            const response = await shippingService.getShippingRegions();
            return res.json(response);
        } catch (error) {
            return next(error);
        }
    });

    route.get('/shipping/regions/:shipping_region_id([0-9]+)', async (req, res, next) => {
        try {
            const {shipping_region_id} = req.params;
            const shippingService = Container.get('shippingService');
            const response = await shippingService.getShippingRegion(shipping_region_id);
            return res.json(response);
        } catch (error) {
            return next(error);
        }
    });
}