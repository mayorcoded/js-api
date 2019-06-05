'use strict';
const { Container } =  require('typedi');
const { CustomError } = require('../utils/errorHelpers');

class ProductModel {

    async getProducts(limit, offset, descriptionLength){
        try {   
            const sql = Container.get('mysql');          
            const row = await sql.query(`SELECT product_id, 
                                                name, 
                                                substring(description, 1, ?) as description, 
                                                price, 
                                                discounted_price, 
                                                thumbnail  
                                                FROM product LIMIT ? OFFSET ?`, 
                                                [descriptionLength,limit, offset]);
            return row;
        } catch (error) {
            throw new CustomError({
                name: "ProductModelError", 
                status: 400, 
                code: "PMDLR_OO", 
                message: error.message, 
                field: ['limit', 'offset']
            });
        }
    }

    async getProduct(product_id){
        try {
            const sql = Container.get('mysql'); 
            const row = await sql.query(`SELECT * FROM product WHERE product_id = ?`, [product_id]);
            return row;
        } catch (error) {
            throw new CustomError({
                name: "ProductModelError", 
                status: 400, 
                code: "PMDLR_O1", 
                message: error.message, 
                field: "product_id" 
            });
        }
    }

    async findProduct(queryString, limit, offset, descriptionLength){
        try {
            const params = [descriptionLength,`${queryString}%`, limit, offset];
            const sql = Container.get('mysql'); 
            const row = await sql.query(`SELECT product_id, 
                                                name, 
                                                substring(description, 1, ?) as description, 
                                                price, 
                                                discounted_price, 
                                                thumbnail 
                                                FROM product WHERE name LIKE ? LIMIT ? OFFSET ?`, params);
            return row;
        } catch (error) {
            throw new CustomError({
                name: "ProductModelError", 
                status: 400, 
                code: "PMDLR_O2", 
                message: error.message, 
                field: "query_string" 
            });
        }
    }

    async getProductCategory(categoryId, limit, offset, descriptionLength){
        try {
            const params = [descriptionLength, categoryId, limit, offset];
            const sql = Container.get('mysql'); 
            const row = await sql.query(`SELECT p.product_id, 
                                                p.name, 
                                                substring(p.description, 1, ?) as description, 
                                                p.price, 
                                                p.discounted_price, 
                                                p.thumbnail,
                                                pc.category_id,
                                                cat.name
                                                FROM product_category as pc 
                                                LEFT OUTER JOIN product as p ON (pc.product_id = p.product_id)
                                                RIGHT OUTER JOIN category as cat ON (pc.category_id = cat.category_id) 
                                                WHERE pc.category_id = ? LIMIT ? OFFSET ?`, params);
            return row;
        } catch (error) {
            throw new CustomError({
                name: "ProductModelError", 
                status: 400, 
                code: "PMDLR_O3", 
                message: error.message, 
                field: "category_id" 
            });
        }
    }

    async getProductDepartment(departmentId, limit, offset, descriptionLength){
        try {
            const params = [descriptionLength ,departmentId, limit, offset];
            const sql = Container.get('mysql'); 
            const row = await sql.query(`SELECT p.product_id as product_id, 
                                                p.name as product_name, 
                                                substring(p.description, 1, ?) as product_description, 
                                                p.price as product_price, 
                                                p.discounted_price as product_discounted_price, 
                                                p.thumbnail as product_thumbnail,
                                                dep.department_id as department_id,
                                                dep.name as department_name
                                                FROM product_category as pc 
                                                JOIN product as p ON (pc.product_id = p.product_id) 
                                                JOIN category as cat ON (pc.category_id = cat.category_id) 
                                                JOIN department as dep ON (cat.department_id = dep.department_id)  
                                                WHERE dep.department_id = ? LIMIT ? OFFSET ?`, params);
            return row;
        } catch (error) {
            throw new CustomError({
                name: "ProductModelError", 
                status: 400, 
                code: "PMDLR_O3", 
                message: error.message, 
                field: "department_id" 
            });
        }
    }

    async getProductDetails(productId){
        try {
            const params = [productId];
            const sql = Container.get('mysql'); 
            const row = await sql.query(`SELECT product_id, 
                                                name, 
                                                description, 
                                                price, 
                                                discounted_price, 
                                                image,
                                                image_2 
                                                FROM product WHERE product_id = ?`, params);
            
            return row;
        } catch (error) {
            throw new CustomError({
                name: "ProductModelError", 
                status: 400, 
                code: "PMDLR_O4", 
                message: error.message, 
                field: "product_id" 
            });
        }
    }

    async getProductLocation(productId){
        try {
            const params = [productId];
            const sql = Container.get('mysql'); 
            const row = await sql.query(`SELECT pc.category_id as category_id,
                                                cat.name as category_name,
                                                dep.department_id as department_id,
                                                dep.name as department_name
                                                FROM product_category as pc 
                                                JOIN product as p ON (pc.product_id = p.product_id) 
                                                JOIN category as cat ON (pc.category_id = cat.category_id) 
                                                JOIN department as dep ON (cat.department_id = dep.department_id)  
                                                WHERE p.product_id = ?`, params);        
            return row;
        } catch (error) {
            throw new CustomError({
                name: "ProductModelError", 
                status: 400, 
                code: "PMDLR_O5", 
                message: error.message, 
                field: "product_id" 
            });
        }
    }

    async getProductReview(productId){
        try {
            const params = [productId];
            const sql = Container.get('mysql'); 
            const row = await sql.query(`SELECT p.name,
                                                r.review,
                                                r.rating,
                                                r.created_on
                                                FROM review as r
                                                RIGHT OUTER JOIN product as p ON (r.product_id = p.product_id)
                                                WHERE p.product_id = ?`, params);
            return row;
        } catch (error) {
            throw new CustomError({
                name: "ProductModelError", 
                status: 400, 
                code: "PMDLR_O6", 
                message: error.message, 
                field: "product_id" 
            });
        }
    }

    async addProductReview(customer_id, productId, review, rating){
        try {
            const params = [customer_id, productId, review, rating];
            const sql = Container.get('mysql'); 
            const row =  await sql.query(`INSERT into review 
                                        (customer_id, product_id, review, rating, created_on) 
                                        values ( ?, ?, ?, ?, localtimestamp())`, params);
            return row;
        } catch (error) {
            throw new CustomError({
                name: "ProductModelError", 
                status: 400, 
                code: "PMDLR_O7", 
                message: error.message, 
                field: "product_id" 
            });
        }
    }
}

Container.set('productModel', new ProductModel())
module.exports = ProductModel;