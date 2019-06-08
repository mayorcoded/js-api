'use strict';
const { Container } =  require('typedi');

const paginate = Symbol('paginate');

class ProductService {

    async getProducts(data){
        try {
            const {page, limit, description_length} = data;
            const { offset, _limit} = this[paginate](page,limit);
            const productModel = Container.get('productModel');
            const products = await productModel.getProducts(_limit, offset, description_length || 200);

            return {
                count: products.length,
                rows: products
            }
        } catch (error) {
            throw error;
        }   
    }

    async searchProducts(data){
        try {
            const {query_string, page, limit, description_length} = data;
            const { offset, _limit} = this[paginate](page,limit);
            const productModel = Container.get('productModel');
            const products = await productModel.findProduct(query_string, _limit, offset, description_length || 200);

            return {
                count: products.length,
                rows: products
            }
        } catch (error) {
            throw error;
        }
    }

    async getProduct(data){
        try {
            const {product_id} = data;
            const productModel = Container.get('productModel');
            const product = await productModel.getProduct(product_id);
            return (product.length > 0)? product[0]: { message: 'product does not exist'};
        } catch (error) {
            throw error;
        }
    }

    async getProductCategory(data){
        try {
            const {category_id} = data.params;
            const {page, limit, description_length} = data.query;

            const { offset, _limit} = this[paginate](page,limit);
            const productModel = Container.get('productModel');
            const products = await productModel.getProductCategory(category_id, _limit, offset, description_length||200);
            return {
                count: products.length,
                rows: products
            }
        } catch (error) {
            throw error;
        } 
    }

    async getProductDepartments(data){
        try {
            const { department_id } = data.params;
            const { limit, page, description_length} = data.query;
            const { offset, _limit} = this[paginate](page,limit);
            const productModel = Container.get('productModel');
            const products = await productModel.getProductDepartment(department_id, _limit, offset, description_length||200);
            return {
                count: products.length,
                rows: products
            }
        } catch (error) {
            throw error;
        }
    }

    async getProductDetails(data){
        try {
            const {product_id} = data;
            const productModel = Container.get('productModel');
            const product = await productModel.getProductDetails(product_id);
            return (product.length > 0)? product[0]: { message: 'product does not exist'};
        } catch (error) {
            throw error;
        }
    }

    async getProductLocations(data){
        try {
            const {product_id} = data;
            const productModel = Container.get('productModel');
            const product = await productModel.getProductLocation(product_id);
            return (product.length > 0)? product[0]: { message: 'product does not exist'};
        } catch (error) {
            throw error;
        }
    }

    async getProductReviews(data){
        try {
            const {product_id} = data;
            const productModel = Container.get('productModel');
            const product = await productModel.getProductReview(product_id);
            return (product.length > 0)? product[0]: { message: 'product does not exist'};
        } catch (error) {
            throw error;
        }
    }

    async addProductReview(data){
        try {
            const {product_id} = data.params;
            const {review, rating, customer_id} = data.body;
            const productModel = Container.get('productModel');
            const product = await productModel.addProductReview(customer_id, product_id,review,rating);
            return product;
        } catch (error) {
            throw error;
        }
    }

    [paginate](page, limit){
        page = page || 1;
        limit = limit || 20;

        let _page = parseInt(page, 10); //convert to an integer
        if (isNaN(_page) || _page < 1) {
            _page = 1;
        }
        let _limit = parseInt(limit, 10); //convert to an integer

        //be sure to cater for all possible cases
        if (isNaN(_limit)) {
            _limit = 10;
        } else if (_limit > 50) {
            _limit = 50;
        } else if (_limit < 1) {
            _limit = 1;
        }
        const offset = (_page - 1) * _limit;

        return {
            offset: offset,
            _limit,
            page: _page
        };
    }
}

module.exports = ProductService;