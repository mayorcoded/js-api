'use strict';
const { Container } =  require('typedi');
const paginate = Symbol('paginate');

class CategoryService {

    async getCategories(page, limit, order){
        try {
            const { offset, _limit} = this[paginate](page,limit);
            const categoryModel = Container.get('CategoryModel');
            const categoryies = await categoryModel.getAllCategories(_limit, offset, order || 'category_id');

            return {
                count: categoryies.length,
                rows: categoryies
            }
        } catch (error) {
            throw error;
        }   
    }

    async getCategory(category_id){
        try {
            const categoryModel = Container.get('CategoryModel');
            const category = await categoryModel.getCategory(category_id);
            return category[0]||{};
        } catch (error) {
            throw error;
        }   
    }

    async getProductCategories(product_id){
        try {
            const categoryModel = Container.get('CategoryModel');
            const productCategories = await categoryModel.getProductCategories(product_id);
            return productCategories;
        } catch (error) {
            throw error;
        }   
    }

    async getDepartmentCategories(department_id){
        try {
            const categoryModel = Container.get('CategoryModel');
            const departmentCategories = await categoryModel.getDepartmentCategories(department_id);
            return departmentCategories;
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

module.exports = CategoryService;