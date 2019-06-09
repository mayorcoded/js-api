'use strict';
const { Container } =  require('typedi');
const { CustomError } = require('../utils/errorHelpers');

class TaxModel{

    async getAllTaxes(){
        try {
            const sql = Container.get('mysql'); 
            const row = await sql.query('SELECT * from tax');
            return row;
        } catch (error) {
            throw new CustomError({
                name: "TaxModelError", 
                status: 400, 
                code: "TXMDLR_OO", 
                message: error.message, 
                field: ['']
            });
        }
    }

    async getTax(tax_id){
        try {
            const sql = Container.get('mysql'); 
            const row = await sql.query('SELECT * from tax WHERE tax_id = ?', [tax_id]);
            return row;
        } catch (error) {
            throw new CustomError({
                name: "TaxModelError", 
                status: 400, 
                code: "TXMDLR_O1", 
                message: error.message, 
                field: ['tax_id']
            });
        }
    }
}

Container.set('TaxModel', new TaxModel())
module.exports = TaxModel;
