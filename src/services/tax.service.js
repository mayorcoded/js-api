'use strict';
const { Container } =  require('typedi');

class TaxService {

    async getAllTaxes(){
        try {
            const taxModel = Container.get('TaxModel');
            const response = await taxModel.getAllTaxes();
            return response;
        } catch (error) {
            throw error;
        }
    }

    async getTax(tax_id){
        try {
            const taxModel = Container.get('TaxModel');
            const response = await taxModel.getTax(tax_id);
            return response;
        } catch (error) {
            throw error;
        }
    }
}

module.exports = TaxService;