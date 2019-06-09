'use strict';
const { Container } =  require('typedi');

class DepartmentsService {

    async getAllDepartments(){
        try {
            const departmentsModel = Container.get('DepartmentsModel');
            const response = await departmentsModel.getAllDepartments();
            return response;
        } catch (error) {
            throw error;
        }
    }

    async getDepartment(department_id){
        try {
            const departmentsModel = Container.get('DepartmentsModel');
            const response = await departmentsModel.getDepartment(department_id);
            return response;
        } catch (error) {
            throw error;
        }
    }
}

module.exports = DepartmentsService;