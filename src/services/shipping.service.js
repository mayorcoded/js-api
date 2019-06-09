'use strict';
const { Container } =  require('typedi');


class ShippingService{
    async getShippingRegions(){
        try {
            const shippingModel = Container.get('ShippingModel');
            const response = await shippingModel.fetchShippingRegions();
            return response;
        } catch (error) {
            throw error;
        }
    }

    async getShippingRegion(shipping_region_id){
        try {
            const shippingModel = Container.get('ShippingModel');
            const response = await shippingModel.fetchShippingRegion(shipping_region_id);
            return response;
        } catch (error) {
            throw error;
        }
    }
}

module.exports = ShippingService;