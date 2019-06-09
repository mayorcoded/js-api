'use strict';
const { Container } =  require('typedi');
const { CustomError } = require('../utils/errorHelpers');

class CategoryModel {

    async getAllCategories(limit, offset, order){
        try {
            const sql = Container.get('mysql'); 
            const row = await sql.query(`SELECT * FROM category
                                            ORDER BY ? DESC 
                                            LIMIT ? 
                                            OFFSET ?`, [order, limit, offset]);
            return row;            
        } catch (error) {
            throw new CustomError({
                name: "CategoryModelError", 
                status: 400, 
                code: "CATMDLR_OO", 
                message: error.message, 
                field: ['limit', 'offset']
            });
        }
    }

    async getCategory(category_id){
        try {
            const sql = Container.get('mysql'); 
            const row = await sql.query(`SELECT * FROM category WHERE category_id = ?`, [category_id]);
            return row;            
        } catch (error) {
            throw new CustomError({
                name: "CategoryModelError", 
                status: 400, 
                code: "CATMDLR_O1", 
                message: error.message, 
                field: ['category_id']
            });
        }
    }

    async getProductCategories(product_id){
        try {
            const sql = Container.get('mysql'); 
            const row = await sql.query(`SELECT cat.category_id, cat.department_id, cat.name
                                            FROM category as cat
                                            LEFT JOIN product_category as pcat
                                            ON (cat.category_id = pcat.category_id)
                                            WHERE product_id = ?`, [product_id]);
            return row;            
        } catch (error) {
            throw new CustomError({
                name: "CategoryModelError", 
                status: 400, 
                code: "CATMDLR_O2", 
                message: error.message, 
                field: ['product_id']
            });
        }
    }

    async getDepartmentCategories(department_id){
        try {
            const sql = Container.get('mysql'); 
            const row = await sql.query(`SELECT * FROM category WHERE department_id = ?`, [department_id]);
            return row;            
        } catch (error) {
            throw new CustomError({
                name: "CategoryModelError", 
                status: 400, 
                code: "CATMDLR_O3", 
                message: error.message, 
                field: ['department_id']
            });
        }
    }
}

Container.set('CategoryModel', new CategoryModel())
module.exports = CategoryModel;