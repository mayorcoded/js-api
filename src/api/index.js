const { Router } = require('express');
const welcome = require('./routes/welcome');

const app = Router();
welcome(app);


module.exports = app;