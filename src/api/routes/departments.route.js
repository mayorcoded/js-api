'use strict';
const { Router } = require('express');
const { Container } =  require('typedi');

const route = Router()

module.exports = async(app) => {
    app.use(route);
    
    route.get('/departments', async (req, res, next) => {
        try {
            const departmentService = Container.get('departmentService');
            const response = await departmentService.getAllDepartments();
            return res.json(response);
        } catch (error) {
            return next(error);
        }
    });

    route.get('/departments/:department_id([0-9]+)', async (req, res, next) => {
        try {
            const {department_id} = req.params;
            const departmentService = Container.get('departmentService');
            const response = await departmentService.getDepartment(department_id)
            return res.json(response);
        } catch (error) {
            return next(error);
        }
    });
}