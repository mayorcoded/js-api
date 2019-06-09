'use strict';
const { Router } = require('express');
const { Container } =  require('typedi');

const route = Router()

module.exports = async(app) => {
    app.use(route);
    
    route.get('/attributes', async (req, res, next) => {
        try {
            const attributeService = Container.get('attributeService');
            const response = await attributeService.getAttributes();
            return res.json(response);
        } catch (error) {
            return next(error);
        }
    });

    route.get('/attributes/:attribute_id([0-9]+)', async (req, res, next) => {
        try {
            const {attribute_id} = req.params;
            const attributeService = Container.get('attributeService');
            const response = await attributeService.getAttribute(attribute_id);
            return res.json(response);
        } catch (error) {
            return next(error);
        }
    });

    route.get('/attributes/values/:attribute_id([0-9]+)', async (req, res, next) => {
        try {
            const {attribute_id} = req.params;
            const attributeService = Container.get('attributeService');
            const response = await attributeService.getAttributeValues(attribute_id);
            return res.json(response);
        } catch (error) {
            return next(error);
        }
    });

    route.get('/attributes/inProduct/:product_id([0-9]+)', async (req, res, next) => {
        try {
            const {product_id} = req.params;
            const attributeService = Container.get('attributeService');
            const response = await attributeService.getProductAttribute(product_id);
            return res.json(response);
        } catch (error) {
            return next(error);
        }
    });
}