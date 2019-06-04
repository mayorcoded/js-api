'use strict';

const fs = require('fs');
const jwt = require('jsonwebtoken');
const PRIVATEKEY  = fs.readFileSync('private.key', 'utf8'); 

const createToken = (data) => {
    return 'Bearer ' + jwt.sign(
        data,
        PRIVATEKEY,
        { expiresIn: 86400 }
    );
};

module.exports = {
    createToken
};