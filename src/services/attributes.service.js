'use strict';
const { Container } =  require('typedi');


class AttributesService{
    
    async getAttributes(){
        try {
            const attributesModel = Container.get('AttributesModel');
            const response = await attributesModel.getAllAttributes();
            return response;
        } catch (error) {
            throw error;
        }
    }

    async getAttribute(attribute_id){
        try {
            const attributesModel = Container.get('AttributesModel');
            const response = await attributesModel.getAttribute(attribute_id);
            return response;
        } catch (error) {
            throw error;
        }
    }

    async getAttributeValues(attribute_id){
        try {
            const attributesModel = Container.get('AttributesModel');
            const response = await attributesModel.getAttributeValues(attribute_id);
            return response;
        } catch (error) {
            throw error;
        }
    }

    async getProductAttribute(product_id){
        try {
            const attributesModel = Container.get('AttributesModel');
            const response = await attributesModel.getProductAttribute(product_id);
            return response;
        } catch (error) {
            throw error;
        }
    }
}

module.exports = AttributesService;