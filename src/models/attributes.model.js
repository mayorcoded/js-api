'use strict';
const { Container } =  require('typedi');
const { CustomError } = require('../utils/errorHelpers');

class AttributesModel {

    async getAllAttributes(){
        try {
            const sql = Container.get('mysql'); 
            const row = await sql.query(`SELECT * FROM attribute`);
            return row;            
        } catch (error) {
            throw new CustomError({
                name: "AttributesModelError", 
                status: 400, 
                code: "ATMDLR_OO", 
                message: error.message, 
                field: ['']
            });
        }
    }

    async getAttribute(attribute_id){
        try {
            const sql = Container.get('mysql'); 
            const row = await sql.query(`SELECT * FROM attribute WHERE attribute_id = ?`, [attribute_id]);
            return row;            
        } catch (error) {
            throw new CustomError({
                name: "AttributesModelError", 
                status: 400, 
                code: "ATMDLR_O1", 
                message: error.message, 
                field: ['category_id']
            });
        }
    }

    async getAttributeValues(attribute_id){
        try {
            const sql = Container.get('mysql'); 
            const row = await sql.query(`SELECT * FROM attribute_value WHERE attribute_id = ?`, [attribute_id]);
            return row;            
        } catch (error) {
            throw new CustomError({
                name: "AttributesModelError", 
                status: 400, 
                code: "ATMDLR_O2", 
                message: error.message, 
                field: ['department_id']
            });
        }
    }

    async getProductAttribute(product_id){
        try {
            const sql = Container.get('mysql'); 
            const row = await sql.query(`SELECT attr.name as attribute_name, 
                                                attrv.attribute_value_id,  
                                                attrv.value as attribute_value
                                        FROM attribute as attr
                                        JOIN attribute_value as attrv 
                                        ON (attr.attribute_id = attrv.attribute_id)
                                        JOIN product_attribute as pattr
                                        ON (pattr.attribute_value_id = attrv.attribute_value_id)
                                        WHERE product_id = ? `, [product_id]);
            return row;            
        } catch (error) {
            throw new CustomError({
                name: "AttributesModelError", 
                status: 400, 
                code: "ATMDLR_O3", 
                message: error.message, 
                field: ['product_id']
            });
        }
    }

    
}

Container.set('AttributesModel', new AttributesModel())
module.exports = AttributesModel;