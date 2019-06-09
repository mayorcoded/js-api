'use strict';

const { Router } = require('express');
const { Container } =  require('typedi');
const cache = require('../middlewares/cache');
const route = Router();

module.exports = async(app) => {
    app.use(route);

    route.get('/categories', cache,  async (req, res, next) => { 
        try {
            const {page, limit, order} = req.query;
            const categoryService = Container.get('categoryService');
            const response = await categoryService.getCategories(page, limit, order);
            return res.json(response);
        } catch (error) {
            return next(error);
        }
    });

    route.get('/categories/:category_id([0-9]+)', cache,  async (req, res, next) => { 
        try {
            const {category_id} = req.params;
            const categoryService = Container.get('categoryService');
            const response = await categoryService.getCategory(category_id);
            return res.json(response);
        } catch (error) {
            return next(error);
        }
    });

    route.get('/categories/inProduct/:product_id([0-9]+)', cache,  async (req, res, next) => { 
        try {
            const {product_id} = req.params;
            const categoryService = Container.get('categoryService');
            const response = await categoryService.getProductCategories(product_id);
            return res.json(response);
        } catch (error) {
            return next(error);
        }
    });

    route.get('/categories/inDepartment/:department_id([0-9]+)', cache,  async (req, res, next) => { 
        try {
            const {department_id} = req.params;
            const categoryService = Container.get('categoryService');
            const response = await categoryService.getDepartmentCategories(department_id);
            return res.json(response);
        } catch (error) {
            return next(error);
        }
    });
}