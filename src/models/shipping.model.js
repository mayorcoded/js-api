'use strict';
const { Container } =  require('typedi');
const { CustomError } = require('../utils/errorHelpers');

class ShippingModel{

    async fetchShippingRegions(){
        try {
            const sql = Container.get('mysql'); 
            const row = await sql.query('SELECT * from shipping_region');
            return row;
        } catch (error) {
            throw new CustomError({
                name: "ShippingModelError", 
                status: 400, 
                code: "SHPMDLR_OO", 
                message: error.message, 
                field: ['']
            });
        }
    }

    async fetchShippingRegion(shipping_region_id){
        try {
            const sql = Container.get('mysql'); 
            const row = await sql.query(`
                    SELECT shp.shipping_id, shp.shipping_type, shp.shipping_cost, shpr.shipping_region, shp.shipping_region_id
                    FROM shipping as shp 
                    JOIN shipping_region as shpr 
                    ON (shp.shipping_region_id = shpr.shipping_region_id)
                    WHERE shp.shipping_region_id = ?`, [shipping_region_id]);
            return row;
        } catch (error) {
            throw new CustomError({
                name: "ShippingModelError", 
                status: 400, 
                code: "SHPMDLR_O1", 
                message: error.message, 
                field: ['shipping_region_id']
            });
        }
    }
}

Container.set('ShippingModel', new ShippingModel())
module.exports = ShippingModel;
