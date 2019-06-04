"use strict";

const filterError = (errors) => {
    const errorSet = new Set()
    const filteredErrors = {
            
    }
    
    if (!errors.isEmpty()) {
        errors.array().forEach((error) => {
            if(filteredErrors[error.param]){
                if(!errorSet.has(error.msg)){
                    let numberOfErrors = Object.keys((filteredErrors[error.param])).length;
                    let errorCode = (numberOfErrors > 9)? "ERR_" + (numberOfErrors + 1) : "ERR_0" + (numberOfErrors + 1);
                    filteredErrors[error.param][errorCode] = error.msg;
                    errorSet.add(error.msg);
                }
                
            }else{
                filteredErrors[error.param] = { "ERR_01" : error.msg }
                errorSet.add(error.msg);
            }
        });

        return filteredErrors;
    }

    return null;
}

class CustomError extends Error{
    constructor(error){
        super();
        this.name = error.name;
        this.message = error.message;
        this.status = error.status;
        this.code = error.code
        this.field = error.field
    }
}

module.exports = {
    filterError,
    CustomError,
}