'use strict';
const { Container } =  require('typedi');
const { CustomError } = require('../utils/errorHelpers');

class DepartmentsModel{

    async getAllDepartments(){
        try {
            const sql = Container.get('mysql'); 
            const row = await sql.query('SELECT * from department');
            return row;
        } catch (error) {
            throw new CustomError({
                name: "DepartmentModelError", 
                status: 400, 
                code: "DEPMDLR_OO", 
                message: error.message, 
                field: ['']
            });
        }
    }

    async getDepartment(department_id){
        try {
            const sql = Container.get('mysql'); 
            const row = await sql.query('SELECT * from department WHERE department_id = ?', [department_id]);
            return row;
        } catch (error) {
            throw new CustomError({
                name: "DepartmentModelError", 
                status: 400, 
                code: "DEPMDLR_O1", 
                message: error.message, 
                field: ['department_id']
            });
        }
    }
}

Container.set('DepartmentsModel', new DepartmentsModel())
module.exports = DepartmentsModel;
